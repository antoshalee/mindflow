module Mindflow
  # Takes original AST and separates it into appropriate files
  class FilesGenerator
    def initialize(root_node, root_dir:)
      @root_node = root_node
      @root_dir  = root_dir
    end

    def generate
      files_hash = {}
      @root_node.traverse do |node|
        if place_node_in_separate_file?(node)
          files_hash[node.file_path] ||= \
            Mindflow::File.new(root_dir: @root_dir,
                               path_to_file: node.file_path)

          files_hash[node.file_path].asts << extract_ast_branch_for_file(node)
        end
      end

      files_hash.values
    end

    private

    def place_node_in_separate_file?(node)
      node.top?
    end

    def extract_ast_branch_for_file(node)
      duplicate_and_exclude_top_children(node).parents_and_self
    end

    def duplicate_and_exclude_top_children(origin_node)
      origin_node.dup.tap do |node|
        node.children = node.children
                            .dup
                            .delete_if(&:top?)
      end
    end
  end
end
