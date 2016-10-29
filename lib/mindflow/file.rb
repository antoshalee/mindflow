module Mindflow
  # Represents generated file
  class File
    attr_reader :asts, :root_dir, :path_to_file

    DEFAULT_DIR = 'lib'.freeze

    def initialize(root_dir:, path_to_file:)
      @asts = []
      @root_dir = root_dir
      @path_to_file = path_to_file
    end

    def write!
      ::File.open(full_path_to_file, 'w') do |f|
        @asts.each do |ast|
          f.write ast.unparse
        end
      end
    end

    def full_path_to_dir
      ::File.expand_path ::File.join(root_dir, path_to_dir)
    end

    def full_path_to_file
      ::File.expand_path ::File.join(root_dir, path_to_file)
    end

    def path_to_dir
      path_to_file.split('/')[0..-2].join('/')
    end
  end
end
