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
      subject { described_class.new }

      context 'confirmation' do
        it 'asks for creation confirmation' do
          FakeFS do
            allow(STDIN).to receive(:gets).and_return('y')
            app = File.expand_path('../../', __FILE__)
            FakeFS::FileSystem.clone(app)
            FileUtils.rm(described_class::CONFIG_PATH) if File.file?(described_class::CONFIG_PATH)
            described_class.new.update_entry('notes_folder', app)

            expect(subject).to receive(:create?).with('workspace')
            subject.switch_workspace('test_worksapce') 
          end
        end
      end
    end
  end

  describe 'creating notebooks' do
    subject { described_class.new }

    context 'confirmation' do
      it 'ask for creation confirmation' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('y')
          app = File.expand_path('../../', __FILE__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(described_class::CONFIG_PATH) if File.file?(described_class::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect(subject).to receive(:create?).with('notebook')
          subject.create_note('test_note', ['new_notebook'])
        end
      end
    end

    context 'user confirmed' do
      it 'creates the notebook' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('y')
          app = File.expand_path('../../', __FILE__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(described_class::CONFIG_PATH) if File.file?(described_class::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect { subject.create_note('test_note', ['new_notebook']) }
            .to change { File.directory?('new_notebook')  }.from(false).to(true)
        end
      end
    end

    context 'user did not consent' do
      it 'does not create the notebook' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('n')
          app = File.expand_path('../../', __FILE__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(described_class::CONFIG_PATH) if File.file?(described_class::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect { subject.create_note('test_note', ['new_notebook']) }
            .to_not change { File.directory?('new_notebook')  }
        end
      end
    end
  end

  describe 'creating notes' do
    context 'note title not specified' do
      it 'should raise an error' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('n')
          app = File.expand_path('../../', __FILE__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(described_class::CONFIG_PATH) if File.file?(described_class::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect { subject.create_note('', ['new_notebook']) }
            .to raise_error(ArgumentError, 'no note title specified')
        end
      end
    end

    context 'notebook not specified' do
      it 'should raise an error' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('n')
          app = File.expand_path('../../', __FILE__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(described_class::CONFIG_PATH) if File.file?(described_class::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect { subject.create_note('test_note', []) }
            .to raise_error(ArgumentError, 'no notebook specified')
        end
      end
    end
  end

  describe 'deleting notes' do
    context 'note title not specified' do
      it 'should raise an error' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('n')
          app = File.expand_path('../../', __FILE__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(described_class::CONFIG_PATH) if File.file?(described_class::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect { subject.delete_note('', ['new_notebook']) }
            .to raise_error(ArgumentError, 'no note title specified')
        end
      end
    end

    context 'notebook not specified' do
      it 'should raise an error' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('n')
          app = File.expand_path('../../', __FILE__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(described_class::CONFIG_PATH) if File.file?(described_class::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect { subject.delete_note('test_note', []) }
            .to raise_error(ArgumentError, 'no notebook specified')
        end
      end
    end
  end
end
