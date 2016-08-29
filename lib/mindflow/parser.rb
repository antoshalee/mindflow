module Mindflow
  # Generates collection
  # of ruby abstract syntax trees
  # compatible with https://github.com/whitequark/parser
  class Parser
    def parse(str)
      @current_indent = -2

      lines = str.split(/\r?\n/)
                 .delete_if { |l| l.match(/\A\s*\z/) } # remove empty lines

      @files = []
      @stack = []

      lines.each { |line| parse_line(line) }
      stack_pop until @stack.empty?

      @files.map { |file| Mindflow::File.new(file.ast) }
    end

    private

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

      line = line.strip
      node = case line
             when CAMELCASE_RE
               parse_camelcase($&, $')
             when UNDERSCORE_RE
               parse_underscore($&, $')
             end
      operate_on_stack(steps, node)
    end

    def operate_on_stack(steps, node)
      (-steps + 1).times { stack_pop } if steps <= 0
      add_to_stack node
    end

    def stack_pop
      @stack.pop.build_ruby_ast!
    end

    def add_to_stack(node)
      if @stack.empty?
        @files << node
      else
        @stack.last.append node
      end

      @stack << node
    end

    def get_indent(line)
      line[/\A\s*/].size
    end

    def parse_camelcase(token, rest_line)
      superclass = rest_line =~ CHAINED_CONSTANTS_RE &&
                   rest_line.strip

      Mindflow::AST::ClassNode.new(token, superclass: superclass)
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
