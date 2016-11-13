require_relative 'unparsing/base_unparser'
require_relative 'unparsing/c_unparser'
require_relative 'unparsing/m_unparser'
require_relative 'unparsing/d_unparser'
require_relative 'unparsing/in_unparser'

module Mindflow
  # This namespace holds concerete nodes unparsers (ruby code generators)
  module Unparsing
    class << self
      def build_unparser_for(node, **options)
        class_name = "Mindflow::Unparsing::#{node.node_name}Unparser"
        Object.const_get(class_name).new(node, **options)
      end
    end
  end
end
