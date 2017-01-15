require_relative "dom_reader"

class NodeRenderer
  attr_reader :types, :counter

  def initialize(tree)
    @tree = tree
    @types = {}
    @counter = 0
  end

  def render(some_node = @tree)
    node_types_frequencies(some_node)
    puts "Total number of nodes below this node:"
    puts "#{@counter}"
    puts "Nodes types and occurrences below this node:"
    get_types
    puts "Attributes in this node"
    puts "#{get_node_data_attributes(some_node)}"
  end

  private

  def get_types
    @types.each {|key, value| puts "#{key} : #{value}"}
  end

  def node_types_frequencies(some_node)
    if some_node.children != nil
      some_node.children.each do |child|
        @counter += 1
        node_types_frequencies(child)
        if @types[child.type] != nil
          @types[child.type] += 1
        else
          @types[child.type] = 1
        end
      end
    end
  end

  def get_node_data_attributes(some_node)
    puts "type: #{some_node.type}"
    puts "class: #{some_node.classes.split( ).join(',')}" if some_node.classes != ""
    puts "id: #{some_node.id}" if some_node.id != ""
    puts "name: #{some_node.name}" if some_node.name != ""
  end

end

# reader = DOMReader.new
# tree = reader.build_tree("test.html")

# renderer = NodeRenderer.new(tree)
# renderer.render()