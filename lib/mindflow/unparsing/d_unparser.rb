module Mindflow::Unparsing
  # Generates ruby method code
  class DUnparser < BaseUnparser
    def unparse
      write_method_definition
      write_end
    end

    private

    def write_method_definition
      line do |l|
        l.write DEF_KW, WS
        l.write node.name
        write_method_args(l)
      end
    end

    def write_end
      write END_KW
      write_nl
      write_nl unless @is_last
    end

    def write_method_args(line)
      return if node.method_args.empty?
      line.write L_PAR
      line.write node.method_args.join ', '
      line.write R_PAR
    end
  end
end
