# Generates collection
# of ruby abstract syntax trees
# compatible with https://github.com/whitequark/parser
class Mindflow::Parser
  # Base class for mindflow AST nodes
  # Node can build ruby AST-subtree
  class BaseNode
    attr_reader :ast
    def initialize(name, options = {})
      @name = name
      @options = options
      @children = []
    end

    def append(node)
      @children << node
    end

    def build_ruby_ast!
      @ast = build_ruby_ast
    end

    def def_body(children = [])
      n(:begin, children)
    end

    def def_method(name, args)
      n(:def, [name.to_sym, n(:args, args), nil])
    end

    def def_arg(arg)
      n(:arg, [arg.to_sym])
    end

    def def_class(name, superclass, body)
      n(:class, [name, superclass, body])
    end

    def def_const(name)
      n(:const, [nil, name.to_sym])
    end

    def n(type, children = [])
      Parser::AST::Node.new(type, children)
    end
  end

  # Represents mindflow method
  class MethodNode < BaseNode
    def build_ruby_ast
      args = n(:args, @options[:args].map { |a| def_arg(a) })
      def_method(@name, args)
    end
  end

  # Represents mindflow class
  class ClassNode < BaseNode
    def build_ruby_ast
      class_name = def_const(@name)
      superclass_name =
        @options[:superclass] && def_const(@options[:superclass])

      def_class(class_name, superclass_name, body)
    end

    def body
      child_asts = @children.map(&:ast)
      child_asts.size == 1 ? child_asts.first : def_body(child_asts)
    end
  end

  # Represents mindflow self scope
  class SelfNode < ClassNode
    def build_ruby_ast
      n(:sclass, [n(:self), body])
    end
  end

  def parse(str)
    @current_indent = -2

    lines = str.split(/\r?\n/)

    @files = []
    @stack = []

    lines.each { |line| parse_line(line) }
    stack_pop until @stack.empty?

    @files.map { |file| Mindflow::File.new(file.ast) }
  end

  private

  CAMELCASE_RE = /([A-Z][a-z0-9]+)+/ # TODO: find a better version for camelcase
  CHAINED_CONSTANTS_RE = /#{CAMELCASE_RE}(\:\:#{CAMELCASE_RE})*/
  UNDERSCORE_RE = /([a-z0-9_]+\!?)/ # TODO: find a better regexp for underscore
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
    ClassNode.new(token.to_sym, superclass: superclass)
  end

  def parse_underscore(token, rest_line)
    return SelfNode.new(token) if token == 'self'

    args = if rest_line =~ ARGS_RE
             rest_line.split(' ')
           else
             []
           end
    MethodNode.new(token, args: args)
  end
end
