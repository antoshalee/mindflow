module Mindflow::Dsl
  # Base class for all nodes
  class BaseNode
    attr_reader :args, :children

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

    protected

    def add_child(node)
      children << node
      node
    end
  end
end
