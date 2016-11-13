module Mindflow::Ast
  # Represents ruby module
  class MNode < BaseNode
    def c(*attrs)
      add_child CNode.new(*attrs)
    end

    def name
      args.first
    end

    def namespace_extender?
      true
    end
  end
end
