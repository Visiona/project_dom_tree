require_relative "dom_reader"
require_relative "node_renderer"

class TreeSearcher
  attr_reader :tree, :solutions

  def initialize(tree)
    @tree = tree
    @solutions = []
  end

  def search_by(attr, word)
    search_descendents(@tree, attr, word)
  end

  def search_descendents(some_node, attr, word)
    @solutions = []
    check_first_node(some_node, attr, word)
    traverse_nodes_down(some_node, attr, word)
    @solutions
  end

  def search_ancestors(some_node, attr, word)
    @solutions = []
    check_first_node(some_node, attr, word)
    traverse_nodes_up(some_node, attr, word)
    @solutions
  end

  private

  def get_node_attr(some_node, attr)
    case attr
    when :name
      some_node.name
    when :text
      some_node.text_content
    when :id
      some_node.id
    when :class
      some_node.classes
    end
  end

  def check_first_node(some_node = @tree, attr, word)
    match_data = get_node_attr(some_node, attr).match(word) if get_node_attr(some_node, attr)
    @solutions << some_node if match_data
  end

  def node_contain_word?(some_node, attr, word)
    if get_node_attr(some_node, attr)
      get_node_attr(some_node, attr).match(word)
    else
      false
    end
  end

  def traverse_nodes_down(some_node = @tree, attr, word)
    current_node = some_node
    if current_node.children != nil
      current_node.children.each do |child|
        if node_contain_word?(child, attr, word)
          @solutions << child
        end
        traverse_nodes_down(child, attr, word)
      end
    end
  end

  def traverse_nodes_up(some_node = @tree, attr, word)
    current_node = some_node
    if current_node.parents != nil
      parent = current_node.parents
      @solutions << parent if node_contain_word?(parent, attr, word)
      traverse_nodes_up(parent, attr, word)
    end
  end

end


# reader = DOMReader.new
# tree = reader.build_tree("test.html")

# searcher = TreeSearcher.new(tree)
# sidebars = searcher.search_by(:text, "unordered")
# renderer = NodeRenderer.new(tree)
# # some_node = """"
# sidebars.each { |node| renderer.render(node) }
# sidebars.each { |node| puts "#{node.inspect}" }
# searcher.search_descendents(some_node, :id, "main-area").each { |node| renderer.render(node) }
# searcher.search_ancestors(some_node, :class, "wrapper")