require 'spec_helper'

describe Mindflow::Parser do
  include AST::Sexp

  subject { described_class.new.parse(source) }

  def ruby_ast(path)
    code = Pathname.new(path).read
    ::Parser::CurrentRuby.parse code
  end

  describe 'valid file examples' do
    let(:source) do
      Pathname.new("#{path_to_examples}/#{n}.mindflow").read
    end

    describe 'valid' do
      let(:path_to_examples) do
        "#{__dir__}/../examples/valid"
      end

      shared_examples 'valid mindflows' do
        let(:paths_to_rb) { Dir["#{path_to_examples}/#{n}*.rb"].sort }

        describe 'subject size' do
          it { expect(subject.size).to eq(paths_to_rb.size) }
        end

        it { expect(subject).to all(be_instance_of Mindflow::File) }

        it 'builds correct ruby ast' do
          paths_to_rb.each_with_index do |path, idx|
            expect(subject[idx].ast).to eq ruby_ast(path)
          end
        end
      end

      context('0') { let(:n) { 0 }; include_examples 'valid mindflows'; }
      context('1') { let(:n) { 1 }; include_examples 'valid mindflows'; }
      context('2') { let(:n) { 2 }; include_examples 'valid mindflows'; }
      context('3') { let(:n) { 3 }; include_examples 'valid mindflows'; }
      context('4') { let(:n) { 4 }; include_examples 'valid mindflows'; }
      context('5') { let(:n) { 5 }; include_examples 'valid mindflows'; }
    end
  end
end
