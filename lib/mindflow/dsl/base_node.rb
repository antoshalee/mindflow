module Mindflow::Dsl
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

    # TODO: very hackish method. Rework!
    def with_ancestors
      if parent.is_a?(ModuleNode)
        node = ModuleNode.new(*parent.args)
        node.children << self.dup
        node
      else
        self
      end
    end

    protected

    def add_child(node)
      children << node
      node.parent = self
      node
    end
  end
end
