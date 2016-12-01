module Mindflow
  # Prints Mindflow AST tree
  class Printer
    def initialize(node)
      @node = node
    end

    def print
      @result = ''
      print_node(@node, 0)
      @result
    end

    private

    def print_node(node, level)
      @result << ws(level)
      @result << node.to_s
      print_children(node.children, level)
    end

    def print_children(children, level)
      children.each do |c|
        @result << "\n"
        print_node(c, level + 1)
      end
    end

    def ws(level)
      '  ' * level
    end
  end
end
