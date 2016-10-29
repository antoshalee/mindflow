require 'spec_helper'

describe 'Ruby generation' do
  before do
    FileUtils.rmdir root_dir
  end

  def ruby_code(path)
    Pathname.new(path).read
  end

  let(:path_to_examples) do
    ::File.expand_path "#{__dir__}/../examples/valid"
  end

  let(:mindflow_path) do
    Pathname.new("#{path_to_examples}/#{n}.mindflow")
  end

  let(:root_dir) do
    ::File.expand_path "#{__dir__}/../../tmp/generation"
  end

  let(:generator) do
    Mindflow::Generator.new mindflow_path,
                            root_dir: root_dir
  end

  let(:paths_to_generated_files) do
    Dir["#{root_dir}/#{n}*.rb"].sort
  end

  before do
    generator.generate
  end

  context 'example 0' do
    let(:n) { 0 }

    it 'works' do
      expected = File.read("#{path_to_examples}/0_1.rb")
      output = File.read("#{root_dir}/lib/post.rb")
      expect(output).to eq expected
    end
  end

  context 'example 1' do
    let(:n) { '1' }

    it 'works' do
      expected = File.read("#{path_to_examples}/1_1.rb")
      output = File.read("#{root_dir}/lib/user.rb")
      expect(output).to eq expected
    end
  end

  context 'example 2' do
    let(:n) { '2' }

    it 'works' do
      expected_1 = File.read("#{path_to_examples}/2_1.rb")
      output_1 = File.read("#{root_dir}/lib/user.rb")
      expect(output_1).to eq expected_1

      expected_2 = File.read("#{path_to_examples}/2_2.rb")
      output_2 = File.read("#{root_dir}/lib/post.rb")
      expect(output_2).to eq expected_2
    end
  end

  context 'example 3' do
    let(:n) { '3' }

    it 'works' do
      expected = File.read("#{path_to_examples}/3_1.rb")
      output = File.read("#{root_dir}/lib/blog/post.rb")
      expect(output).to eq expected
    end
  end
end
