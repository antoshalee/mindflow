module Mindflow::Ast
  class RootNode < BaseNode
    def c(*attrs)
      add_child CNode.new(*attrs)
    end

    def m(*attrs)
      add_child MNode.new(*attrs)
    end
  end
end
