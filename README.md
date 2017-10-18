#  Own HTML Parser with RSpec tests

The idea behind this project is to rearrange the HTML markup in test.html into DOM. `dom_reader.rb` holds a class DOMReader. It will take the html markup string (`html_loader.rb`), parses it into Struct object containing key attributes. The effect is a data structured tree which is scanned with a searching algorithm. The searching for a specific information is done via TreaSearcher class in `tree_searcher.rb`.
- `node_renderer.rb` - hold NodeRenderer class which takes in a tree and allows you to output key statistics about any of its nodes and their sub-trees.
- `dom_rebuilder.rb` - reverts the whole process, which is to rebuild the original HTML file from the node tree.

There is provided a simple test file (lib/test.html) which mimics type of files that are regularly scrapped.

## Getting Started

If you want to quick run some the examples to see the code in action, run
```
$ ruby example.rb
```
from the lib folder in project directory. If you want to check the files individually, you can uncomment code at the bottom and insert properties. Especially in `tree_searcher.rb` you can uncomment code at the bottom and choose what tags or classes to look for in the test.html.

## Authors

* **Dariusz Biskupski** - *Initial work* - https://dariuszbiskupski.com


## Acknowledgments

It is part of the assignment created for [Viking Code School](https://www.vikingcodeschool.com/)
