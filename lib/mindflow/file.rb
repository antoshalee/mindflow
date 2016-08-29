module Mindflow
  class File
    attr_reader :ast

    DEFAULT_DIR = 'lib'.freeze

    def initialize(ast, location: DEFAULT_DIR)
      @ast = ast
      @location = location
    end

    def relative_path
      "#{@location}/#{name}.rb"
    end

    private

    # TODO: dummy logic
    def name
      @ast.children[0].children[1]
    end
  end
end
