module Mindflow::Dsl
  class ModuleNode < BaseNode
    def c(*attrs)
      add_child ClassNode.new(*attrs)
    end

    def name
      args.first
    end

    def namespace_extender?
      true
    end
  end
end
