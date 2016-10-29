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

  context 'example 0' do
    let(:n) { 0 }

    it 'works' do
      expected = File.read("#{path_to_examples}/0_1.rb")
      generator.generate
      output = File.read("#{root_dir}/lib/post.rb")
      expect(output).to eq expected
    end
  end

  context 'example 1' do
    let(:n) { '1' }

    it 'works' do
      expected = File.read("#{path_to_examples}/1_1.rb")
      generator.generate
      output = File.read("#{root_dir}/lib/user.rb")
      expect(output).to eq expected
    end
  end

  context 'example 2' do
    let(:n) { '2' }

    it 'works' do
      expected_1 = File.read("#{path_to_examples}/2_1.rb")
      generator.generate
      output_1 = File.read("#{root_dir}/lib/user.rb")
      expect(output_1).to eq expected_1
    end
  end
end
