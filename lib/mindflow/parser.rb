module Mindflow
  # Parses mindflow input string and generates AST
  class Parser
    def parse(str)
      @current_indent = -2

      lines = build_lines(str)

      @stack = []

      Ast::RootNode.new.tap do |root_node|
        add_to_stack root_node
        lines.each { |line| parse_line line }
      end
    end

    private

    def build_lines(str)
      str.split(/\r?\n/)
         .delete_if { |l| l.match(/\A\s*\z/) } # remove empty lines
    end

    TAB_SIZE = 2
    def parse_line(line)
      indent = get_indent(line)

      steps = (indent - @current_indent) / TAB_SIZE
      @current_indent = indent

      (-steps + 1).times { stack_pop }

      add_to_stack build_node(line)
    end

    # TODO: test on edge cases
    TOKENS_SEPARATOR = ' '.freeze
    def build_node(line)
      method, *args = line.split(TOKENS_SEPARATOR)

      @stack.last.add_child(method, *args)
    end

    def stack_pop
      @stack.pop
    end

    def add_to_stack(node)
      @stack << node
    end

    def get_indent(line)
      line[/\A\s*/].size
    end
  end
end
