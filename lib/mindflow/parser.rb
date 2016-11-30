module Mindflow
  # Parses mindflow input string and generates AST
  class Parser
    def parse(str)
      @prev_indent = -2

      lines = build_lines(str)

      @stack = []

      Ast::RootNode.new.tap do |root_node|
        add_to_stack root_node
        lines.each { |line| parse_line line }
      end
    end

    private

    attr_reader :stack

    LINES_SPLITTER_REGEXP = /\r?\n/
    EMPTY_LINES_REGEXP    = /\A\s*\z/
    INDENT_REGEXP         = /\A\s*/
    TOKENS_SEPARATOR      = ' '.freeze

    def build_lines(str)
      str.split(LINES_SPLITTER_REGEXP)
         .delete_if { |l| l.match(EMPTY_LINES_REGEXP) } # remove empty lines
    end

    TAB_SIZE = 2
    def parse_line(line)
      indent_for(line) do |indent|
        stack_pop_times_for(indent).times { stack.pop }
      end

      add_to_stack build_node(line)
    end

    # TODO: test on edge cases
    def build_node(line)
      method, *args = line.split(TOKENS_SEPARATOR)

      stack.last.add_child(method, *args)
    end

    def add_to_stack(node)
      stack << node
    end

    def indent_for(line)
      indent = line[INDENT_REGEXP].size

      yield indent

      @prev_indent = indent
    end

    def stack_pop_times_for(indent)
      1 - steps_delta(indent)
    end

    def steps_delta(indent)
      (indent - @prev_indent) / TAB_SIZE
    end
  end
end
