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

          files_hash[node.file_path].asts << ast_branch_for_file(node)
        end
      end

      files_hash.values
    end

    private

    def place_node_in_separate_file?(node)
      node.top?
    end

    def ast_branch_for_file(node)
      dup = duplicate_and_exclude_top_children(node)
      path = dup.path
      path.last.children = dup.children

      build_tree!(path)
    end

    def build_tree!(path)
      path.each_with_index do |n, index|
        child = path[index + 1]
        n.children << child if child
      end
      path.first # root
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
