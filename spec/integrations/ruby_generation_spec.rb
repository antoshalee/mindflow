require 'spec_helper'

describe 'Ruby generation' do
  before do
    FileUtils.rmdir root_dir, verbose: true
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
      expect(File.read("#{path_to_examples}/1_1.rb"))
        .to eq File.read("#{root_dir}/lib/user.rb")
    end
  end

  context 'example 2' do
    let(:n) { '2' }

    it 'works' do
      expect(File.read("#{path_to_examples}/2_1.rb"))
        .to eq File.read("#{root_dir}/lib/user.rb")

      expect(File.read("#{path_to_examples}/2_2.rb"))
        .to eq File.read("#{root_dir}/lib/post.rb")
    end
  end

  context 'example 3' do
    let(:n) { '3' }

    it 'works' do
      expect(File.read("#{path_to_examples}/3_1.rb"))
        .to eq File.read("#{root_dir}/lib/blog/post.rb")
    end
  end

  context 'example 4' do
    let(:n) { '4' }

    it 'works' do
      expect(File.read("#{path_to_examples}/4_1.rb"))
        .to eq File.read("#{root_dir}/lib/blog.rb")

      expect(File.read("#{path_to_examples}/4_2.rb"))
        .to eq File.read("#{root_dir}/lib/blog/post.rb")
    end
  end

  context 'example 5' do
    let(:n) { '5' }

    it 'works' do
      expect(File.read("#{path_to_examples}/5_1.rb"))
        .to eq File.read("#{root_dir}/lib/user.rb")
    end
  end

  context 'example 6' do
    let(:n) { '6' }

    it 'works' do
      expect(File.read("#{path_to_examples}/6_1.rb"))
        .to eq File.read("#{root_dir}/lib/blog.rb")

      expect(File.read("#{path_to_examples}/6_2.rb"))
        .to eq File.read("#{root_dir}/lib/blog/post.rb")

      expect(File.read("#{path_to_examples}/6_3.rb"))
        .to eq File.read("#{root_dir}/lib/blog/post/comment.rb")

      expect(File.read("#{path_to_examples}/6_4.rb"))
        .to eq File.read("#{root_dir}/lib/blog/post/comment/tag.rb")
    end
  end
end
