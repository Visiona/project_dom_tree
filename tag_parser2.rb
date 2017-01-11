

def parse_tag_to_tree(html_str)
  node = Struct.new(:type, :classes, :id, :name, :text_content, :children, :parents)
  parser = node.new
  parser.type = html_str.scan(/<[a-z0-9]+/)[0][1..-1] if html_str[0] != " "
  parser.classes = html_str.scan(/class='(.*?)'/).join.split(" ")
  parser.id = html_str.scan(/id='(.*?)'/).join
  parser.name = html_str.scan(/name='(.*?)'/).join
  parser.children = []
  parser.parents = nil
  parser
end

def detect_first_open_tag(html_str)
  (/<[^\/].*?>/ =~ html_str) == 0
end

def detect_first_close_tag(html_str)
  (/<[\/].*?>/ =~ html_str) == 0
end

def detect_first_text(html_str)
  (/^[^<>]+/ =~ html_str) == 0
end

def build_root_get(html_str)
  parse_tag_to_tree(html_str)
end

def building_tag_child(current_node, html_str)
  new_child = parse_tag_to_tree(html_str)
  new_child.parents = current_node
  current_node.children << new_child
  current_node
end

def building_text_child(current_node, html_str)
  text_node = parse_tag_to_tree(html_str)
  text_node.type = "text"
  text_node.text_content = html_str[0 ... (/</ =~ html_str)]
  text_node.children = nil
  text_node.parents = current_node
  current_node.children << text_node
  current_node
end

def get_trimmed_html(html_str)
  case
  when detect_first_open_tag(html_str)
    html_str[(/>/ =~ html_str) + 1 .. -1]
  when detect_first_close_tag(html_str)
    html_str[(/>/ =~ html_str) + 1 .. -1]
  when detect_first_text(html_str)
    html_str[(/</ =~ html_str) .. -1]
  end
end

def parser_script(html_str)
  root = build_root_get(html_str)
  current_node = root
  current_html = get_trimmed_html(html_str)
  while current_html.length > 0
    if detect_first_open_tag(current_html)
      current_node = building_tag_child(current_node, current_html)
      current_html = get_trimmed_html(current_html)
      current_node = current_node.children.last
    elsif detect_first_close_tag(current_html)
      current_node = current_node.parents
      current_html = get_trimmed_html(current_html)
    elsif detect_first_text(current_html)
      current_node = building_text_child(current_node, current_html)
      current_html = get_trimmed_html(current_html)
    end
  end
  root
end

def opening_tag_printer(current_node)
  if current_node.type != "text"
    puts
    print "<#{current_node.type}"
    print " class=#{current_node.classes}" if current_node.classes != []
    print " id=#{current_node.classes}" if current_node.id != ""
    print " name=#{current_node.name}" if current_node.name != ""
    print ">"
  else
    puts
    print "#{current_node.text_content}"
  end
end

def closing_tag_printer(current_node)
  if current_node.type != "text"
    puts
    print "</#{current_node.type}"
    print ">"
  end
end

def outputter(data_structure)
  current_node = data_structure
  opening_tag_printer(current_node)
  if current_node.children != nil
    current_node.children.each do |child|
      outputter(child)
      if child.children == nil || child.children == []
        closing_tag_printer(current_node) if child == current_node.children.last
      end
    end
  end
end

html_str = "<div>  div text before  <p>    p text  </p>  <div>    more div text  </div>  div text after</div>"

data_structure = parser_script(html_str)

puts "DBG: data_structure = #{data_structure.inspect}"
puts "PRINT OUT"
outputter(data_structure)
