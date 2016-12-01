require 'spec_helper'

describe Mindflow::Printer do
  subject { described_class.new(node).print }

  let(:node) do
    Mindflow::Ast::CNode.new('Blog').tap do |node|
      node.add_child('c', 'Post').tap do |c|
        c.add_child('d', 'publish', 'publish_date')
      end

      node.add_child('d', 'add_post')
    end
  end

  let(:expected) do
'C Blog
  C Post
    D publish publish_date
  D add_post'
  end

  it 'prints mindflow format ast' do
    expect(subject).to eq expected
  end
end
