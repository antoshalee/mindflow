module Mindflow::Dsl
  class ModuleNode < BaseNode
    def c(*attrs)
      add_child ClassNode.new(*attrs)
    end

    def name
      args.first
    end
  end
end
