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
  let(:root_node) { reader.build_tree("lib/test.html") }

  before do
    reader
    root_node
  end

  describe "#build_tree" do

    describe "parser handles simple tags" do

      it "parser handles first html tag" do
        expect(root_node.type).to eq("html")
      end

      it "parser handles one of the root children's tag" do
        expect(root_node.children[1].type).to eq("body")
      end

    end

    describe "parser handles tags with attributes" do

      it "parser handles class of one of the deeper tags" do
        expect(root_node.children[1].children[0].classes).to eq("top-div")
      end

      it "parser handles id of one of the deeper tags"  do
        expect(root_node.children[1].children[1].id).to eq("main-area")
      end

      it "parser dosn't have class if there is no class in the tag"  do
        expect(root_node.children[0].children[0].classes).to eq("")
      end

    end

    describe "parser handle simple nested tags" do

      it "parser handles tag second level deep" do
        expect(root_node.children[1].children[0].type).to eq("div")
      end

      it "parser handles tag third level deep" do
        expect(root_node.children[1].children[0].children[1].type).to eq("div")
      end

       it "parser handles tag fourth level deep" do
        expect(root_node.children[1].children[1].children[0].children[0].type).to eq("h1")
      end

    end


    describe "parser handle text both before and after a nested tag" do

      it "parser handles text on shallow level" do
        expect(root_node.children[0].children[0].children[0].text_content).to eq("This is a test page")
      end

      it "parser handle text on deeper level before inline tag" do
        expect(root_node.children[1].children[0].children[1].children[0].text_content).to eq("I'm an inner div!!! I might just ")
      end

      it "parser handle text between tags" do
        expect(root_node.children[1].children[0].children[1].children[1].children[0].text_content).to eq("emphasize")
      end

    end

    describe "tree have the correct number of total nodes" do
      let(:reader2) { DOMReader.new}

      it "checking total number of nodes" do
        reader2.build_tree("spec/small.html")
        expect(reader2.nodes_number).to eq(13)
      end

    end

  end
end

