require 'spec_helper'

describe Mindflow do
  it 'has a version number' do
    expect(Mindflow::VERSION).not_to be nil
  end

  # Future feature
  it 'parses' do
    pending
    path = Pathname.new "#{__dir__}/fixtures/some_ruby_code.rb"
    ::Parser::CurrentRuby.parse path.read
    expect(true).to eq true
  end
end
