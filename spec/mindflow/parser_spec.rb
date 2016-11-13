require 'spec_helper'

describe Mindflow::Parser do
  subject { described_class.new.parse(input) }

  context 'valid mindflow' do
    let(:input) do
<<-EOS
c User
  c Class
EOS
    end

    it 'calls methods on nodes' do
      user_class_node = double

      expect_any_instance_of(Mindflow::Ast::RootNode)
        .to receive(:add_child).with('c', 'User')
        .and_return(user_class_node)

      expect(user_class_node)
        .to receive(:add_child).with('c', 'Class')
        .and_return(user_class_node)

      subject
    end
  end
end
