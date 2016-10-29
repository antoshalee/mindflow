module Mindflow::Dsl
  class ClassNode < BaseNode
    def m
      add_child ModuleNode.new
    end

    def cl(*attrs)
      add_child ClassNode.new(*attrs)
    end

    def d(*attrs)
      add_child MethodNode.new(*attrs)
    end

    def p
      add_child PathNode.new
    end

    def name
      args.first
    end

    def superclass
      args[1]
    end

    def fileable?
      true
    end

    def file_path
      "lib/#{name.downcase}.rb"
    end
  end
end