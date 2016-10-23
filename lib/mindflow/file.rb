module Mindflow
  class File
    attr_reader :ast, :location

    DEFAULT_DIR = 'lib'.freeze

    def initialize(ast, location: DEFAULT_DIR)
      @ast = ast
      @location = location
    end

    alias path_to_dir location

    def path
      "#{@location}/#{name}.rb"
    end

    def name
      @ast.children[0].children[1]
    end
  end
end
