require "dom_reader"
require "node_renderer"
require "tree_searcher"

describe TreeSearcher do

  let(:reader) { DOMReader.new }
  let(:root_node) { reader.build_tree("lib/test.html") }
  let(:searcher) { TreeSearcher.new(root_node) }

  before do
    reader
    root_node
    searcher
  end

  describe "#search_by" do

    it "finds result of searching for word in class name - root level" do
      nodes = searcher.search_by(:class, "important")
      match_data = nodes[0].classes.match("important")
      expect(match_data[0]).to eq("important")
    end

    it "finds result of searching for word in text" do
      nodes = searcher.search_by(:text, "unordered")
      match_data = nodes[0].text_content.match("unordered")
      expect(match_data[0]).to eq("unordered")
    end

  end

  describe "#search_ancestors" do

    it "finds result of searching for word in id above a random node" do
      some_node = searcher.search_by(:class, "emphasized")
      found_node = searcher.search_ancestors(some_node[0],:id, "main-area")
      match_data = found_node[0].id.match("main-area")
      expect(match_data[0]).to eq("main-area")
    end

    it "doesn't find result of searching for word in text below a random node" do
      some_node = searcher.search_by(:class, "emphasized")
      found_node = searcher.search_ancestors(some_node[0], :text, "the test doc!")
      match_data = found_node[0] #.id.match("the test doc!")
      expect(match_data).to be_falsey
    end

  end

  describe "#search_descendants" do

    it "finds result of searching for word in text below a random node" do
      some_node = searcher.search_by(:id, "main-area")
      found_node = searcher.search_descendents(some_node[0],:text, "One h1")
      match_data = found_node[0].text_content.match("One h1")
      expect(match_data[0]).to eq("One h1")
    end

    it "doesn't find result of searching for word in class in ancestor of random node" do
      some_node = searcher.search_by(:class, "super-header")
      found_node = searcher.search_descendents(some_node[0], :id, "main-area")
      match_data = found_node[0] #.id.match("the test doc!")
      expect(match_data).to be_falsey
    end

  end

end

