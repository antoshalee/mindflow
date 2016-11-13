module Mindflow::Ast
  # Represents ruby method (d for def)
  class DNode < BaseNode
    attr_reader :name, :method_args

    def initialize(*args)
      super
      @name, *@method_args = args
    end
  end
end
