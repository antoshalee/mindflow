module Mindflow
  class Parser2
    def parse(str)
      @current_indent = -2

      lines = build_lines(str)

      @stack = []

      root_node = Dsl::RootNode.new
      add_to_stack root_node

      lines.each { |line| parse_line(line) }

      root_node
    end

    private

    def build_lines(str)
      str.split(/\r?\n/)
         .delete_if { |l| l.match(/\A\s*\z/) } # remove empty lines
    end

    # TODO: find a better regexps
    CAMELCASE_RE = /([A-Z][a-z0-9]*)+/
    CHAINED_CONSTANTS_RE = /#{CAMELCASE_RE}(\:\:#{CAMELCASE_RE})*/
    UNDERSCORE_RE = /([a-z0-9_]+\!?)/
    ARGS_RE = /#{UNDERSCORE_RE}(\s#{UNDERSCORE_RE})*/

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

      @stack.last.send(method, *args)
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

    def parse_camelcase(token, rest_line)
      superclass = rest_line =~ CHAINED_CONSTANTS_RE &&
                   rest_line.strip

      name = (current_namespace << token).join '::'
      Mindflow::AST::ClassNode.new(name, superclass: superclass)
    end

    def current_namespace
      @stack.select { |n| n.instance_of?(Mindflow::AST::ClassNode) }
            .map(&:name)
    end

    def parse_underscore(token, rest_line)
      return Mindflow::AST::SelfNode.new(token) if token == 'self'

      args = if rest_line =~ ARGS_RE
               rest_line.split(' ')
             else
               []
             end
      Mindflow::AST::MethodNode.new(token, args: args)
    end
  end
end
