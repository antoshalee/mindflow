module Mindflow
  module Ast
    module TreeSupport
      def traverse(&block)
        children.each do |node|
          yield node
          node.traverse(&block)
        end
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

      def add_child(node)
        children << node
        node.parent = self
        node
      end
    end
  end
end
