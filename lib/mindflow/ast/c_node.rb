module Mindflow::Ast
  # Represents ruby class
  class CNode < BaseNode
    def m
      add_child MNode.new
    end

    def c(*attrs)
      add_child CNode.new(*attrs)
    end

    def d(*attrs)
      add_child DNode.new(*attrs)
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

    def place_in_separate_file?
      true
    end
  end
end
