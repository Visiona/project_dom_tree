require "dom_reader.rb"
require "html_loader.rb"

describe DOMReader do

  # let(:test_html) do "<html>
  #                 <head>
  #                   <title>
  #                     This is a test page
  #                   </title>
  #                 </head>
  #                 <body>
  #                   <div class=\"top-div\">
  #                     I'm an outer div!!!
  #                     <div class=\"inner-div\">
  #                       I'm an inner div!!! I might just <em>emphasize</em> some text.
  #                     </div>
  #                     I am EVEN MORE TEXT for the SAME div!!!
  #                   </div>
  #                 </body>
  #               </html>" 
  # end
  let(:reader) { DOMReader.new }
  let(:root_node) { reader.build_tree(test.html) }

  before do
    reader
    root_node
  end

  describe "#build_tree" do

    describe "parser handles simple tags" do

      it "parser handles first html tag" do
        expect(root_node.type).to eq("html")
      end

      # it "parser handle tags with attributes" do
        
      # end

      # it "parser handle simple nested tags" do
        
      # end

      # it "parser handle text both before and after a nested tag" do
        
      # end

      # it "tree have the correct number of total nodes" do
        
      # end

    end


    describe "parser handles simple tags" do

    # it "parser handles simple tags" do
    #   expect(tree.type).to eq("html")
    # end

    # it "parser handle tags with attributes" do
      
    # end

    # it "parser handle simple nested tags" do
      
    # end

    # it "parser handle text both before and after a nested tag" do
      
    # end

    # it "tree have the correct number of total nodes" do
      
    # end

    end


    describe "parser handles simple tags" do

    # it "parser handles simple tags" do
    #   expect(tree.type).to eq("html")
    # end

    # it "parser handle tags with attributes" do
      
    # end

    # it "parser handle simple nested tags" do
      
    # end

    # it "parser handle text both before and after a nested tag" do
      
    # end

    # it "tree have the correct number of total nodes" do
      
    # end

    end


    describe "parser handles simple tags" do

    # it "parser handles simple tags" do
    #   expect(tree.type).to eq("html")
    # end

    # it "parser handle tags with attributes" do
      
    # end

    # it "parser handle simple nested tags" do
      
    # end

    # it "parser handle text both before and after a nested tag" do
      
    # end

    # it "tree have the correct number of total nodes" do
      
    # end

    end

    describe "parser handles simple tags" do

    # it "parser handles simple tags" do
    #   expect(tree.type).to eq("html")
    # end

    # it "parser handle tags with attributes" do
      
    # end

    # it "parser handle simple nested tags" do
      
    # end

    # it "parser handle text both before and after a nested tag" do
      
    # end

    # it "tree have the correct number of total nodes" do
      
    # end

    end

  end
end

