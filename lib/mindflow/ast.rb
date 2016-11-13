require_relative 'ast/base_node'
require_relative 'ast/root_node'
require_relative 'ast/c_node'
require_relative 'ast/m_node'
require_relative 'ast/d_node'
require_relative 'ast/in_node'

module Mindflow
  module Ast
    class UnacceptableChildError < StandardError; end
  end
end
