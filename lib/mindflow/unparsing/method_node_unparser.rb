module Mindflow::Unparsing
  # Generate ruby class code
  class MethodNodeUnparser < BaseUnparser
    def unparse
      line do |l|
        l.write DEF_KW, WS
        l.write node.name
        write_method_args(l)
      end
      write END_KW
      write_nl
      write_nl
    end

    private

    def write_method_args(line)
      if node.method_args.size > 0
        line.write L_PAR
        line.write node.method_args.join ', '
        line.write R_PAR
      end
    end
  end
end
