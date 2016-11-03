module Mindflow::Dsl
  class ClassNode < BaseNode
    def m
      add_child ModuleNode.new
    end

    def c(*attrs)
      add_child ClassNode.new(*attrs)
    end

    def d(*attrs)
      add_child MethodNode.new(*attrs)
    end

    def p
      add_child PathNode.new
    end

    def in(*attrs)
      add_child InNode.new(*attrs)
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
      path_parts = ['lib']
      path_parts += namespace.map(&:downcase)
      path_parts << "#{name.downcase}.rb"
      path_parts.join '/'
    end

    def namespace
      [parent.name].compact
    end

    def namespace_extender?
      true
    end

    def should_be_placed_in_separate_file?
      true
    end
  end
end
