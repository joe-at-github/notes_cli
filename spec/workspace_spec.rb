require_relative '../workspace'
require 'fakefs/safe'

RSpec.describe Workspace do
  describe '#initialize' do
    context 'config.yml' do
      subject { described_class.new }

      it 'creates a config.yml if one does not already exists' do
        FakeFS do
          app = File.expand_path('../../', __FILE__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(described_class::CONFIG_PATH) if File.file?(described_class::CONFIG_PATH)
          expect { subject }.to change { File.file?(described_class::CONFIG_PATH) }
            .from(false).to(true)
        end
      end
    end
  end
end