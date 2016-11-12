module Mindflow
  # Reads mindflow specification
  # located at input_path
  # and generates equivalent ruby file(s)
  class Generator
    attr_reader :root_dir

    def initialize(input_path, root_dir:)
      @input_path = input_path
      @root_dir = root_dir
    end

    def generate
      files.each do |file|
        FileUtils.mkdir_p file.full_path_to_dir
        file.write!
      end
    end

    private

    def files
      Mindflow::FilesGenerator.new(ast, root_dir: @root_dir).generate
    end

    def ast
      Mindflow::Parser.new.parse(input)
    end

    def input
      Pathname.new(@input_path).read
    end
  end
end
