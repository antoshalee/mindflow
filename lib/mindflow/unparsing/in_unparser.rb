module Mindflow::Unparsing
  # Generate initializer with attributes assignment
  class InUnparser < DUnparser
    def unparse
      write_method_definition
      write_assignments
      write_end
    end

    private

    def write_assignments
      return if node.method_args.empty?
      node.method_args.each do |arg|
        line do |l|
          write_indent(2)
          l.write AT
          l.write arg
          l.write WS
          l.write ASSIGNMENT
          l.write WS
          l.write arg
        end
      end
    end
  end
end
