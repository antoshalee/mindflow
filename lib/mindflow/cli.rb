require 'mindflow'
require 'pathname'

module Mindflow
  class CLI
    def initialize(argv)
      @argv = argv
    end

    def run
      files.each do |file|
        puts Unparser.unparse(file.ast)
      end
    end

    private

    def files
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
