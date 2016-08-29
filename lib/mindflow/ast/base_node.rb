class Mindflow::AST
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

    # param chain should be an array of constant chunks
    # e.g. ['ActiveSupport', 'Deprecation', 'Behaviour']
    def def_const(chain)
      name = chain.pop
      ns = chain.empty? ? nil : def_const(chain)
      n(:const, [ns, name.to_sym])
    end

    def n(type, children = [])
      Parser::AST::Node.new(type, children)
    end
  end
end
