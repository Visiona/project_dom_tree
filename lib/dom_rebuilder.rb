require_relative "dom_reader"


class DOMRebuilder

  INLINE_TAGS = ["em", "li"]

  def initialize(tree)
    @tree = tree
  end

  def outputter(current_node = @tree)
    opening_tag_printer(current_node)
    if current_node.children != nil
      current_node.children.each { |child| outputter(child) }
    else
      while current_node.parents != nil && is_this_last_child?(current_node)
        closing_tag_printer(current_node.parents)
        current_node = current_node.parents
        current_node.children = []
      end
    end
  end

  private

  def opening_tag_printer(current_node)
    if current_node.type != "text"
      print_in_or_newline_tags(current_node)
    else
      print_in_or_newline_text(current_node)
    end
  end

  def closing_tag_printer(current_node)
    if current_node.type != "text"
      if INLINE_TAGS.include? current_node.type
        print "</#{current_node.type}"
        print ">"
        puts
      else
        puts
        print "</#{current_node.type}"
        print ">"
      end
    end
  end

  def print_tag(current_node)
    print "<#{current_node.type}"
    print " class=\"#{current_node.classes}\"" if current_node.classes != ""
    print " id=\"#{current_node.id}\"" if current_node.id != ""
    print " name=\"#{current_node.name}\"" if current_node.name != ""
    print ">"
  end

  def print_in_or_newline_tags(current_node)
    if INLINE_TAGS.include? current_node.type
      print_tag(current_node)
    else
      puts
      print_tag(current_node)
    end
  end

  def print_in_or_newline_text(current_node)
    if INLINE_TAGS.include? current_node.parents.type
      print "#{current_node.text_content}"
    else
      puts
      print "#{current_node.text_content}"
    end
  end

  def remove_4indent_spaces(current_node)
  end

  def is_this_last_child?(current_node)
    current_node == current_node.parents.children.last
  end

end

reader = DOMReader.new
tree = reader.build_tree("test.html")

recreater = DOMRebuilder.new(tree)
recreater.outputter

