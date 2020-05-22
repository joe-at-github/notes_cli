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

  describe 'switching workspaces' do
    context 'given the workspace did not exist' do
      subject { described_class.new.switch_workspace('test_worksapce') }

      it 'asks for creation confirmation' do
        FakeFS do
          allow_any_instance_of(described_class).to receive(:gets).and_return('y')
          app = File.expand_path('../../', __FILE__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(described_class::CONFIG_PATH) if File.file?(described_class::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          message = 'this workspace does not currently exist and will be created,'\
                    " do you wish to continue?\n"
          expect { subject }.to output(message).to_stdout
        end
      end
    end
  end
end
