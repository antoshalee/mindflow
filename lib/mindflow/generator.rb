require 'fileutils'

module Mindflow
  # Reads mindflow file and generates equivalent ruby file(s)
  #
  # Example (test.mindflow specifies Post and User classes):
  #
  #   Generator.new('test.mindflow', root_dir: 'tmp/mindflow').generate
  #
  # Will generate files:
  #
  # tmp/mindflow/lib/post.rb
  # tmp/mindflow/lib/user.rb
  class Generator
    def initialize(path_to_mindflow, root_dir:)
      @path_to_mindflow = path_to_mindflow
      @root_dir = root_dir
    end

    def generate
      files.each do |file|
        ::FileUtils.mkdir_p file.full_path_to_dir
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
      Pathname.new(@path_to_mindflow).read
    end
  end
end
