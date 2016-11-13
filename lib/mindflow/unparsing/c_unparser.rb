module Mindflow::Unparsing
  # Generate ruby class code
  class CUnparser < BaseUnparser
    def unparse
      write_class_definition

      @buffer
    end

    private

    def write_class_definition
      line do |l|
        l.write CLASS_KW, WS, node.name
        write_superclass(l)
      end
      unparse_children
      write END_KW
      write_nl
    end

    def write_superclass(line)
      return unless node.superclass
      line.write WS, L_ARR, WS, node.superclass
    end
  end
end
