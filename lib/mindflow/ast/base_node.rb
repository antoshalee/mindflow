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

    def place_in_separate_file?
      false
    end

    def dup_with_excluded_children
      dup.tap do |node|
        node.children = node.children
                            .dup
                            .delete_if(&:place_in_separate_file?)
      end
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

    protected

    def add_child_node(node)
      children << node
      node.parent = self
      node
    end

    def dup_with_args
      self.class.new(*args)
    end
  end
end
