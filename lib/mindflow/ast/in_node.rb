module Mindflow::Ast
  # `in` stands for `initialize`
  # This node represents common pattern of
  # constructor with instance variables assignment
  #
  # def initialize(foo, bar)
  #   @foo = foo
  #   @bar = bar
  # end
  class InNode < MethodNode
    METHOD_NAME = 'initialize'.freeze

    def initialize(*args)
      super(*([METHOD_NAME] + args))
    end
  end
end
