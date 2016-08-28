require 'spec_helper'

describe Mindflow::Parser do
  include AST::Sexp

  subject { described_class.new.parse(source) }

  describe 'file examples' do
    context 'example1' do
      let(:source) do
        Pathname.new("#{__dir__}/../fixtures/example1.mind").read
      end

      let(:ast) do
        ruby = Pathname.new("#{__dir__}/../fixtures/example1.rb").read
        ::Parser::CurrentRuby.parse ruby
      end

      it 'works' do
        expect(subject.size).to eq 1
        expect(subject.first).to be_instance_of(Mindflow::File)
        expect(subject.first.ast).to eq ast
      end
    end
  end
end
