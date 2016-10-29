module Mindflow
  # Takes original AST and separates it into appropriate file paths
  class FilesGenerator
    def initialize(root_node, root_dir:)
      @root_node = root_node
      @root_dir  = root_dir
    end

    def generate
      files_hash = {}
      @root_node.traverse do |node|
        if node.fileable?
          files_hash[node.file_path] ||= \
            Mindflow::File.new(root_dir: @root_dir,
                               path_to_file: node.file_path)

          files_hash[node.file_path].asts << node
        end
      end

      files_hash.values
    end
  end
end
