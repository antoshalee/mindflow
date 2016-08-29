require 'mindflow'
require 'pathname'

module Mindflow
  class CLI
    def initialize(argv)
      @argv = argv
    end

    def run
      puts Unparser.unparse(ast)
    end

    def ast
      Mindflow::Parser.new.parse(input)
    end

    def input
      Pathname.new(path).read
    end

    def path
      "#{Dir.pwd}/#{@argv[0]}"
    end
  end
end
