module Mindflow::Unparsing
  class BaseUnparser
    def initialize(node, buffer: String.new, indent: 0)
      @node = node
      @buffer = buffer
      @indent = indent
    end

    WS = ' '.freeze
    NL = "\n".freeze
    L_PAR = '('.freeze
    R_PAR = ')'.freeze
    L_ARR = '<'.freeze # TODO: not sure about the constant name
    CLASS_KW = 'class'.freeze
    DEF_KW = 'def'.freeze
    END_KW = 'end'.freeze

    private

    attr_reader :node

    class Line
      def initialize(buffer, indent)
        @buffer = buffer
        indent.times { @buffer << WS }
      end

      def write(*words)
        words.each { |w| @buffer << w }
      end
    end

    def line
      l = Line.new(@buffer, @indent)
      yield l
      @buffer << NL
    end

    def write(*words)
      @indent.times { @buffer << WS }
      words.each { |w| @buffer << w }
    end

    # Dont write indents
    def write_nl
      @buffer << NL
    end

    def unparse_children
      node.children.each do |node|
        Mindflow::Unparsing
          .build_unparser_for(node, buffer: @buffer,
                                    indent: (@indent + 2)).unparse
      end
    end
  end
end
