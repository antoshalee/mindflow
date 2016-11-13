module Mindflow::Unparsing
  # Generates ruby module code
  class MNodeUnparser < BaseUnparser
    def unparse
      write_module_definition

      @buffer
    end

    private

    def write_module_definition
      line do |l|
        l.write MODULE_KW, WS, node.name
      end
      unparse_children
      write END_KW
      write_nl
    end
  end
end
