require_relative "html_loader"
require_relative "dom_rebuilder"
require_relative "tree_searcher"

class DOMReader
  attr_accessor :root, :type, :classes, :id, :name, :text_content, :children, :parents, :nodes_number

  def initialize
    @nodes_number = 1
  end

  def load_html(file_location)
    HtmlLoader.new(file_location).load
  end

  def build_tree(file_location = "test.html")
    document = load_html(file_location)
    root = build_root(document)
    current_node = root
    current_html = remaininng_html(document)
    while current_html.length > 0
      if detect_first_open_tag(current_html)
        current_node = building_tag_child(current_node, current_html)
        current_html = remaininng_html(current_html)
        current_node = current_node.children.last
        @nodes_number += 1
      elsif detect_first_close_tag(current_html)
        current_node = current_node.parents
        current_html = remaininng_html(current_html)
      elsif detect_first_text(current_html)
        @nodes_number += 1
        current_node = building_text_child(current_node, current_html)
        current_html = remaininng_html(current_html)
      end
    end
    root
  end

  private

  def parse_tag_to_node(document)
    first_tag = trimmed_piece_of_html(document)
    node = Struct.new(:type, :classes, :id, :name, :text_content, :children, :parents)
    parsed_tag = node.new
    parsed_tag.type = ""
    match_class_data = first_tag.match(/class=('|")(.*?)('|")>/)
    match_class_data ? parsed_tag.classes = match_class_data[2] : parsed_tag.classes = ""

    match_id_data = first_tag.match(/id=('|")(.*?)('|")>/)
    match_id_data ? parsed_tag.id = match_id_data[2] : parsed_tag.id = ""

    match_name_data = first_tag.match(/name=('|")(.*?)('|")>/)
    match_name_data ? parsed_tag.name = match_name_data[2] : parsed_tag.name = ""

    parsed_tag.children = []
    parsed_tag.parents = nil
    parsed_tag
  end


  def detect_first_open_tag(document)
    (/<[^\/].*?>/ =~ document) == 0
  end

  def detect_first_close_tag(document)
    (/<[\/].*?>/ =~ document) == 0
  end

  def detect_first_text(document)
    (/^[^<>]+/ =~ document) == 0
  end

  def build_root(document)
    root = parse_tag_to_node(document)
    root.type = document.scan(/<[a-z0-9]+/)[0][1..-1] if document[0] != " "
    root
  end

  def building_tag_child(current_node, document)
    new_child = parse_tag_to_node(document)
    new_child.parents = current_node
    new_child.type = document.scan(/<[a-z0-9]+/)[0][1..-1] if document[0] != " "
    current_node.children << new_child
    current_node
  end

  def building_text_child(current_node, document)
    text_node = parse_tag_to_node(document)
    text_node.type = "text"
    text_node.text_content = document[0 ... (/</ =~ document)]
    text_node.children = nil
    text_node.parents = current_node
    current_node.children << text_node
    current_node
  end

  def remaininng_html(document)
    case
    when detect_first_open_tag(document)
      document[(/>/ =~ document) + 1 .. -1]
    when detect_first_close_tag(document)
      document[(/>/ =~ document) + 1 .. -1]
    when detect_first_text(document)
      document[(/</ =~ document) .. -1]
    end
  end

  def trimmed_piece_of_html(document)
    case
    when detect_first_open_tag(document)
      document[0 .. (/>/ =~ document)]
    when detect_first_close_tag(document)
      document[0 .. (/>/ =~ document)]
    when detect_first_text(document)
      document[0 .. (/</ =~ document)]
    end
  end

end

# reader = DOMReader.new
# tree = reader.build_tree("test.html")
