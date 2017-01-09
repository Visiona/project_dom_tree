

def parse_tag_to_tree(html_str)
  node = Struct.new(:type, :classes, :id, :name, :text_content, :children, :parents)
  parser = node.new
  if html_str[0] == "<"
    parser.type = html_str.scan(/<[a-z0-9]+/)[0][1..-1]
  else
    parser.type = "text"
    parser.text_content = html_str
  end
  parser.classes = html_str.scan(/class='(.*?)'/).join.split(" ")
  parser.id = html_str.scan(/id='(.*?)'/).join
  parser.name = html_str.scan(/name='(.*?)'/).join
  parser.children = []
  parser.parents = nil
  parser
end

def opening_tag_printer(current_node)
  if current_node.type != "text"
    print "<#{current_node.type}"
    print " class=#{current_node.classes}" if current_node.classes != []
    print " id=#{current_node.classes}" if current_node.id != ""
    print " name=#{current_node.name}" if current_node.name != ""
    print ">"
  else
    print "#{current_node.text_content}"
  end
end

def closing_tag_printer(current_node)
  if current_node.type != "text"
    print "</#{current_node.type}"
    print ">"
  end
end

def chop_html_opening_tag(html_string, closing_tag_idx)
  html_string[closing_tag_idx+1..-1]
end

def index_of_first_opening_tag(html_string)
  (/<[^\/].*?>/ =~ html_string)
end

def index_of_first_closing_tag(html_string)
  (/<[\/].*?>/ =~ html_string)
end




def parser_script(html_string)
  current_node = nil
  while html_string.length != 0
    if index_of_first_opening_tag(html_string) == 0 # ie. <p>
      closing_tag_idx = (/>/ =~ html_string)
      if current_node == nil
        current_node = parse_tag_to_tree(html_string[0..closing_tag_idx])
        html_string = chop_html_opening_tag(html_string, closing_tag_idx)
      else
        new_tag_node = parse_tag_to_tree(html_string[0..closing_tag_idx])
        new_tag_node.parents = current_node
        current_node.children << new_tag_node
        current_node = new_tag_node
        html_string = chop_html_opening_tag(html_string, closing_tag_idx)
      end
    elsif index_of_first_closing_tag(html_string) == 0 #ie. </p>
      current_node = current_node.parents
      closing_tag_idx = (/>/ =~ html_string)
      html_string = html_string[closing_tag_idx+1..-1]
    else # ie. >  text <
      closing_tag_idx = (/</ =~ html_string) # index of closing tag
      new_tag_node = parse_tag_to_tree(html_string[0...closing_tag_idx])
      new_tag_node.parents = current_node
      current_node.children << new_tag_node
      current_node = new_tag_node
      html_string = html_string[closing_tag_idx..-1]
    end
  end
  current_node
end



def outputter(data_structure)
  current_node = data_structure
  opening_tag_printer(current_node)
  if current_node.children == []
    closing_tag_printer(current_node.parents)
    puts
  end
  current_node.children.each do |child|
    outputter(child)
  end
end

html_string = "<div>  div text before  <p>    p text  </p>  </div>"

puts "#{parser_script(html_string)}"

data_structure = parser_script(html_string)
puts "PRINT OUT"
outputter(data_structure)
