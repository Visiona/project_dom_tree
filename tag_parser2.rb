

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

# def detect_first_html_tag(html_str)
#   case html_str
#   when (/<[^\/].*?>/ =~ html_str) == 0
#     "open_tag"
#   when (/<[\/].*?>/ =~ html_str) == 0
#     "close_tag"
#   when (/[a-z]/ =~ html_str) == 0
#     "text"
#   end
# end

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
  puts "DBG: text_node = #{text_node.inspect}"
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

def parser_script(html_str, current_node = build_root_get(html_str))
  puts "DBG: current_node = #{current_node.inspect}"
  current_html = get_trimmed_html(html_str)
  puts "DBG: current_html_start = #{current_html.inspect}"
  puts "DBG: current_node.type = #{current_node.type.inspect}"
  while current_html.length != 0
    if detect_first_open_tag(current_html)
      current_node = building_tag_child(current_node, current_html)
      puts "DBG: current_html_open = #{current_html.inspect}"
      current_node.children.each {|child| parser_script(current_html, child) if child.type != "text"}
    elsif detect_first_close_tag(current_html)
      current_node = current_node.parents
      current_html = get_trimmed_html(current_html)
      "DBG: current_html_in_close = #{current_html.inspect}"
    elsif detect_first_text(current_html)
      current_node = building_text_child(current_node, current_html)
      current_html = get_trimmed_html(current_html)
      "DBG: current_html_in_text = #{current_html.inspect}"
    end
    puts "DBG: current_html_after_if = #{current_html.inspect}"
  end
  current_node
end


# def chop_html_opening_tag(html_str, closing_tag_idx)
#   html_str[closing_tag_idx+1..-1]
# end

# def index_of_first_opening_tag(html_str)
#   (/<[^\/].*?>/ =~ html_str)
# end

# def index_of_first_closing_tag(html_str)
#   (/<[\/].*?>/ =~ html_str)
# end




# def parser_script(html_str)
#   current_node = nil
#   while html_str.length != 0
#     if index_of_first_opening_tag(html_str) == 0 # ie. <p>
#       closing_tag_idx = (/>/ =~ html_str)
#       if current_node == nil
#         current_node = parse_tag_to_tree(html_str[0..closing_tag_idx])
#         html_str = chop_html_opening_tag(html_str, closing_tag_idx)
#       else
#         new_tag_node = parse_tag_to_tree(html_str[0..closing_tag_idx])
#         new_tag_node.parents = current_node
#         current_node.children << new_tag_node
#         current_node = new_tag_node
#         html_str = chop_html_opening_tag(html_str, closing_tag_idx)
#       end
#     elsif index_of_first_closing_tag(html_str) == 0 #ie. </p>
#       current_node = current_node.parents
#       closing_tag_idx = (/>/ =~ html_str)
#       html_str = html_str[closing_tag_idx+1..-1]
#     else # ie. >  text <
#       closing_tag_idx = (/</ =~ html_str) # index of closing tag
#       new_tag_node = parse_tag_to_tree(html_str[0...closing_tag_idx])
#       new_tag_node.parents = current_node
#       current_node.children << new_tag_node
#       current_node = new_tag_node
#       html_str = html_str[closing_tag_idx..-1]
#     end
#   end
#   current_node
# end

=begin
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
=end
html_str = "<div>  div text before  <p>    p text  </p>  </div>"

puts "#{parser_script(html_str)}"

# data_structure = parser_script(html_str)
# puts "PRINT OUT"
# outputter(data_structure)
