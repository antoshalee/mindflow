module Mindflow::Ast
  # Represents ruby class
  class CNode < BaseNode
    acceptable_children :m, :c, :d, :p, :in

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
      (parent.namespace + [parent.name]).compact
    end

    def namespace_extender?
      true
    end

    def top?
      true
    end
  end
end
