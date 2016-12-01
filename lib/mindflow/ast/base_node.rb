module Mindflow
  module Ast
    # Base class for all nodes
    class BaseNode
      include TreeSupport

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

      def add_child(method_or_node, *attrs)
        return super if method_or_node.is_a?(BaseNode)

        method = method_or_node

        if self.class.child_allowed?(method)
          child_class = Object.const_get("Mindflow::Ast::#{method.capitalize}Node")
          super child_class.new(*attrs)
        else
          raise UnacceptableChildError,
                "Unacceptable child '#{method}' for '#{node_name}' node"
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

      def dup_only_args
        self.class.new(*args)
      end
    end
  end
end
