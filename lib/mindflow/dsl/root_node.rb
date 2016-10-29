module Mindflow::Dsl
  class RootNode < BaseNode
    def c(*attrs)
      add_child ClassNode.new(*attrs)
    end
  end
end
