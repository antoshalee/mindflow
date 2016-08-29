class Mindflow::AST
  # Represents mindflow class
  class ClassNode < BaseNode
    def build_ruby_ast
      class_name = def_const(@name.split('::'))
      superclass_name =
        @options[:superclass] && def_const(@options[:superclass].split('::'))

      def_class(class_name, superclass_name, body)
    end

    def body
      child_asts = @children.map(&:ast)
      case child_asts.size
      when 0
        nil
      when 1
        child_asts.first
      else
        def_body(child_asts)
      end
    end
  end
end
