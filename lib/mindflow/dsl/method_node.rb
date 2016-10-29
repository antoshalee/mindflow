module Mindflow::Dsl
  class MethodNode < BaseNode
    attr_reader :name, :method_args

    def initialize(*args)
      super
      @name, *@method_args = args
    end
  end
end
