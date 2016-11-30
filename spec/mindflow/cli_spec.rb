require 'spec_helper'
require 'mindflow/cli'

describe Mindflow::Cli do
  subject { described_class.new(argv) }

  context 'wrong extension' do
    let(:argv) { ['test.miflow'] }

    specify do
      expect { subject }
        .to raise_error(Mindflow::Cli::InvalidFileExtension)
    end
  end
end
