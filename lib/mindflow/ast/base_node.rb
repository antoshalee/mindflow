module Mindflow::Ast
  # Base class for all nodes
  class BaseNode
    attr_reader :args
    attr_accessor :parent, :children

    class << self
      def acceptable_children(*children)
        @acceptable_children = children
      end

      def child_allowed?(child)
        @acceptable_children.include?(child.to_sym)
      end
    end

    def initialize(*args)
      @args = args
      @children = []
    end

    def add_child(method, *attrs)
      if self.class.child_allowed?(method)
        child_class = Object.const_get("Mindflow::Ast::#{method.capitalize}Node")
        add_child_node child_class.new(*attrs)
      else
        raise UnacceptableChildError,
              "Unacceptable child '#{method}' for '#{node_name}' node"
      end
    end

    def traverse(&block)
      children.each do |node|
        yield node
        node.traverse(&block)
      end
    end

    def file_path
      raise NotImplementedError
    end

    def unparse
      Mindflow::Unparsing.build_unparser_for(self).unparse
    end

    def namespace
      []
    end

    def name
      nil
    end

    def root
      parent.nil? ? self : parent.root
    end

    def path
      path_to_root.reverse
    end

    def path_to_root
      result = []

      node = self
      while node && !node.is_a?(RootNode)
        result << node.dup_only_args
        node = node.parent
      end

      result
    end

    def namespace_extender?
      false
    end

    def top?
      false
    end

    # Example:
    #
    #   Mindflow::Ast::RootNode.new.node_name => 'Root'
    #   Mindflow::Ast::CNode.new.node_name => 'C'
    #   Mindflow::Ast::InNode.new.node_name => 'In'
    def node_name
      class_name = self.class.to_s.split('::').last
      i = class_name.rindex('Node')
      class_name[0..(i - 1)]
    end

    def inspect
      "\n" + Mindflow::Printer.new(self).print
    end

    def to_s
      ([node_name] + args).join ' '
    end

    protected

    def add_child_node(node)
      children << node
      node.parent = self
      node
    end

    def dup_only_args
      self.class.new(*args)
    end
  end
end
