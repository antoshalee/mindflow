module Mindflow::Ast
  # Represents ruby module
  class MNode < BaseNode
    acceptable_children :c

    def name
      args.first
    end

    def namespace_extender?
      true
    end
  end
end
