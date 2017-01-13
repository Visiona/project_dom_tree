
class DOMRebuilder

  def initialize(tree)
    @tree = tree
  end

  def outputter
    current_node = @tree
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

  private

  def opening_tag_printer(current_node)
    if current_node.type != "text"
      puts
      print "<#{current_node.type}"
      print " class=#{current_node.classes}" if current_node.classes != []
      print " id=#{current_node.id}" if current_node.id != ""
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

end