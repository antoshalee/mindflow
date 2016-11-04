module Mindflow::Ast
  # Base class for all nodes
  class BaseNode
    attr_reader :args
    attr_accessor :parent, :children

    def initialize(*args)
      @args = args
      @children = []
    end

    def traverse(&block)
      children.each do |node|
        yield node
        node.traverse(&block)
      end
    end

    def fileable?
      false
    end

    def file_path
      raise NotImplementedError
    end

    def unparse
      Mindflow::Unparsing.build_unparser_for(self).unparse
    end

    def name
      nil
    end

    def extract_ast_branch_for_file
      dup_with_excluded_children.parents_and_self
    end

    # TODO: considers only one level parent
    def parents_and_self
      if parent.namespace_extender?
        node = parent.dup_with_args
        node.children << dup
        node
      else
        dup
      end
    end

    def namespace_extender?
      false
    end

    def should_be_placed_in_separate_file?
      false
    end

    def dup_with_excluded_children
      dup.tap do |node|
        node.children = node.children
                            .dup
                            .delete_if(&:should_be_placed_in_separate_file?)
      end
    end

    protected

    def add_child(node)
      children << node
      node.parent = self
      node
    end

    def dup_with_args
      self.class.new(*args)
    end
  end
end
