module Mindflow
  # Reads mindflow specification
  # located at input_path
  # and generates equivalent ruby file
  class Generator
    attr_reader :root_dir

    def initialize(input_path, root_dir:)
      @input_path = input_path
      @root_dir = root_dir
    end

    def generate
      root_node = Mindflow::Parser2.new.parse(input)

      files = Mindflow::FilesGenerator.new(root_node, root_dir: @root_dir)
                                      .generate

      files.each do |m_file|
        # m_file stands for Mindflow::File to separate them
        # from the system File instances
        FileUtils.mkdir_p m_file.full_path_to_dir
        m_file.write!
      end
    end

    private

    def full_path_to_dir(file)
      ::File.expand_path ::File.join(root_dir, file.path_to_dir)
    end

    def full_path_to_file(file)
      ::File.expand_path ::File.join(root_dir, file.path)
    end

    def files
      Mindflow::Parser.new.parse(input)
    end

    def input
      Pathname.new(@input_path).read
    end
  end
end
