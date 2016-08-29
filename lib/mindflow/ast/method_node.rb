class Mindflow::AST
  # Represents mindflow method
  class MethodNode < BaseNode
    def build_ruby_ast
      args = n(:args, @options[:args].map { |a| def_arg(a) })
      def_method(@name, args)
    end
  end
end
