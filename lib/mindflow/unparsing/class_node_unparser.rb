module Mindflow::Unparsing
  # Generate ruby class code
  class ClassNodeUnparser < BaseUnparser
    def unparse
      write_class_definition

      @buffer
    end

    private

    def write_class_definition
      line do |l|
        l.write CLASS_KW, WS
        l.write node.name
      end
      unparse_children
      write END_KW
      write_nl
    end
  end
end
