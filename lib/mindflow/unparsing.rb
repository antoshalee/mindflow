require_relative 'unparsing/base_unparser'
require_relative 'unparsing/class_node_unparser'
require_relative 'unparsing/module_node_unparser'
require_relative 'unparsing/method_node_unparser'
require_relative 'unparsing/in_node_unparser'

module Mindflow
  # Unparsing namespace. Holds concerete nodes unparsers
  # (ruby code generators)
  module Unparsing
    class << self
      def build_unparser_for(node, **options)
        self_class_name = node.class.to_s.split('::').last
        class_name = "Mindflow::Unparsing::#{self_class_name}Unparser"
        Object.const_get(class_name).new(node, **options)
      end
    end
  end
end
