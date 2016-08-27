require 'spec_helper'

describe Mindflow::Parser do
  include AST::Sexp

  subject { described_class.new.parse(source) }

  # it 'todo delete' do
  #   path = Pathname.new "#{__dir__}/../fixtures/some_ruby_code.rb"
  #   ast = ::Parser::CurrentRuby.parse path.read
  # end

  context 'simple class with 2 methods' do
    let(:source) do
      "
User
  initialize
  say_hello(to)
"
    end

    let(:ast) do
      s(:class,
        s(:const, nil, :User), nil,
        s(:begin,
          s(:def, :initialize,
            s(:args), nil),
          s(:def, :say_hello,
            s(:args,
              s(:arg, :to)), nil)))
    end

    it 'works' do
      expect(subject).to eq ast
    end
  end
end
