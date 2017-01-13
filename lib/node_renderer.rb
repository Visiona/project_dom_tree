require_relative "dom_reader"

class NodeRenderer

  def initialize(tree)
    @tree = tree
  end

  def render(some_node = @tree)
    puts "There are #{nodes_counter} total nodes in the sub-tree below this node"
    puts "There are following node type with adequate frequency in the sub-tree below this node"
    puts "#{get_types}"
    puts "There are following attributes in this node"
    puts "#{get_node_data_attributes(some_node)}"
  end

  private

  def nodes_counter
    @counter = 0
  end

  def get_types
    @types = {}
    @types.each {|key, value| puts "#{key} : #{value}"}
  end

  def node_types_frequencies(some_node)
    if some_node.children != nil
      some_node.children.each do |child|
        @counter += 1
        node_types_frequencies(child)
        if @types.(child.type) != nil
          @types[child.type] += 1
        else
          @types[child.type] = 0
        end
      end
    end
  end

  def get_node_data_attributes(some_node)
    puts "type: #{some_node.type}"
    puts "class: #{some_node.classes}"
    puts "id #{some_node.id}"
    puts "name #{some_node.name}"
  end

end

reader = TreeBuilder.new
tree = reader.build_tree

renderer = NodeRenderer.new(tree)
renderer.render()