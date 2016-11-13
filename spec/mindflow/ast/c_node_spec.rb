require 'spec_helper'

describe Mindflow::Ast::CNode do
  subject { described_class.new(class_name) }

  let(:class_name) { 'User' }

  it 'allows to add d nodes' do
    expect { subject.add_child('d', 'initialize') }.not_to raise_error
  end

  it 'does not allow to add foo nodes' do
    expect { subject.add_child('foo', 'bat') }
      .to raise_error(Mindflow::Ast::UnacceptableChildError)
  end
end
