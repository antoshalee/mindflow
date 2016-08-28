require 'spec_helper'

describe Mindflow::Parser do
  include AST::Sexp

  subject { described_class.new.parse(source) }

  def ast(filename)
    code = Pathname.new("#{__dir__}/../fixtures/#{filename}").read
    ::Parser::CurrentRuby.parse code
  end

  describe 'file examples' do
    let(:source) do
      Pathname.new("#{__dir__}/../fixtures/#{example}.mindflow").read
    end

    context 'example1' do
      let(:example) { 1 }

      it 'works' do
        expect(subject.size).to eq 1
        expect(subject.first).to be_instance_of(Mindflow::File)
        expect(subject.first.ast).to eq ast('1_1.rb')
      end
    end

    context 'example2' do
      let(:example) { 2 }

      it 'works' do
        expect(subject.size).to eq 2
        expect(subject.first.ast).to eq ast('2_1.rb')
        expect(subject.last.ast).to eq ast('2_2.rb')
      end
    end

    context 'example3' do
      let(:example) { 3 }

      it 'works' do
        expect(subject.size).to eq 1
        expect(subject.first).to be_instance_of(Mindflow::File)
        expect(subject.first.ast).to eq ast('3_1.rb')
      end
    end
  end
end
