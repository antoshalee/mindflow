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
        expect(subject).to eq ast
      end
    end
  end
end
