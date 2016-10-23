module Unparser
  class Emitter
    class Class < self
      private

      def dispatch
        write(K_CLASS, WS)
        visit(name)
        emit_superclass
        emit_body
        k_end
        write(NL) # Added this line
      end
    end

    class Def < self
      private

      def dispatch
        write(K_DEF, WS)
        emit_name
        comments.consume(node, :name)
        emit_arguments
        emit_body
        k_end
        write(NL) # Added this line
      end
    end
  end
end
