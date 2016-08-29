class Mindflow::AST
  # Represents mindflow self scope
  class SelfNode < ClassNode
    def build_ruby_ast
      n(:sclass, [n(:self), body])
    end
  end
end
