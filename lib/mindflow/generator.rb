module Mindflow
  # Reads mindflow specification
  # located at input_path
  # and generates equivalent ruby file
  class Generator
    attr_reader :output_dir

    def initialize(input_path, output_dir:)
      @input_path = input_path
      @output_dir = output_dir
    end

    def generate
      files = Mindflow::Parser.new.parse(input)

      # ruby_ast = Mindflow::AST::Processor.new.process(mindflow_ast)
      files.each do |m_file|
        # m_file stands for Mindflow::File to separate them
        # from the system File instances
        ruby = ::Unparser.unparse(m_file.ast)

        path_to_dir = full_path_to_dir(m_file)
        FileUtils.mkdir_p path_to_dir

        ::File.open(full_path_to_file(m_file), 'w') do |f|
          f.write ruby
        end
      end
    end

    private

    def full_path_to_dir(file)
      ::File.expand_path ::File.join(output_dir, file.path_to_dir)
    end

    def full_path_to_file(file)
      ::File.expand_path ::File.join(output_dir, file.path)
    end

    def files
      Mindflow::Parser.new.parse(input)
    end

    def input
      Pathname.new(@input_path).read
    end
  end
end
