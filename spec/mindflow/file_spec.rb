require 'spec_helper'

describe Mindflow::File do
  describe '#relative_path' do
    let(:ast) do
      name = Parser::AST::Node.new(:const, [nil, :user])
      Parser::AST::Node.new(:class, [name, nil, nil])
    end

    subject { described_class.new(ast).relative_path }

    it 'located in lib by default' do
      expect(subject).to eq 'lib/user.rb'
    end

    context 'with given location' do
      subject { described_class.new(ast, location: 'models').relative_path }

      it 'located in givent location' do
        expect(subject).to eq 'models/user.rb'
      end
    end
  end
end
