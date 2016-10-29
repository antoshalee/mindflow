module Mindflow::Dsl
  class RootNode < BaseNode
    def cl(*attrs)
      add_child ClassNode.new(*attrs)
    end
  end
end
