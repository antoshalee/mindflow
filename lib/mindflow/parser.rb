# Parse mindflow string and returns Ruby AST
class Mindflow::Parser
  def parse(str)
    lines = str.split(/\r?\n/)

    @stack = []

    lines.each { |line| parse_line(line) }

    @stack.map do |node|
      if node.first == :class
        methods = node[2][:methods].map do |m|
          args = n(:args, m[1].map { |a| def_arg(a) })
          def_method(m.first, args)
        end

        body = methods.size == 1 ? methods.first : def_body(methods)

        ast = def_class(def_const(node[1]), nil, body)
        Mindflow::File.new(ast)
      else
        nil
      end
    end
  ensure
    @stack = []
  end

  CAMELCASE_RE = /([A-Z][a-z0-9]+)+/ # TODO: find a better version for camelcase
  UNDERSCORE_RE = /([a-z0-9_]+\!?)/ # TODO: find a better regexp for underscore
  ARGS_RE = /#{UNDERSCORE_RE}(\s#{UNDERSCORE_RE})*/

  def parse_line(line)
    line = line.strip
    case line
    when CAMELCASE_RE
      @stack << [:class, line, { methods: [] }]
    when UNDERSCORE_RE
      parse_method($&, $')
    end
  end

  def parse_method(method_name, rest_line)
    if @stack.last.first == :class

      args = if rest_line =~ ARGS_RE
               rest_line.split(' ')
             else
               []
             end

      @stack.last[2][:methods] << [method_name, args]
    end
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
