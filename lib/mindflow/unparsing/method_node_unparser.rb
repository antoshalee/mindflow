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
      write_nl unless @is_last
    end

    private

    def write_method_args(line)
      return if node.method_args.empty?
      line.write L_PAR
      line.write node.method_args.join ', '
      line.write R_PAR
    end
  end
end
