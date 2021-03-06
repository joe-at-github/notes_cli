# frozen_string_literal: true

require File.expand_path(File.join('..', 'lib', 'notes_cli'), __dir__)

RSpec.describe Workspace do
  describe '#initialize' do
    context 'config.yml' do
      subject { described_class.new }

      it 'creates a config.yml if one does not already exists' do
        FakeFS do
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)

          expect { subject }.to change { File.file?(NotesCli::CONFIG_PATH) }
            .from(false).to(true)
        end
      end
    end
  end

  describe '#editor' do
    context 'no editor set' do
      subject { described_class.new }

      it 'raises an error' do
        FakeFS do
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)

          expect { subject.editor }.to raise_error(StandardError, 'Please set your editor')
        end
      end
    end

    context 'editor setup' do
      subject { described_class.new }

      it 'doesnt raise an error' do
        FakeFS do
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('editor', 'test_editor')

          expect { subject.editor }.to_not raise_error
        end
      end
    end
  end

  describe '#current_workspace' do
    context 'no workspace setup' do
      subject { described_class.new }

      it 'raises an error' do
        FakeFS do
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)

          expect { subject.current_workspace }.to raise_error(StandardError, 'Please set your workspace')
        end
      end
    end

    context 'workspace setup' do
      subject { described_class.new }

      it 'doesnt raise an error' do
        FakeFS do
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect { subject.current_workspace }.to_not raise_error
        end
      end
    end
  end

  describe '#notes_folder' do
    context 'no notes folder setup' do
      subject { described_class.new }

      it 'raises an error' do
        FakeFS do
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect { subject.notes_folder }
            .to raise_error(StandardError, 'Please set your notes_folder')
        end
      end
    end

    context 'notes folder setup' do
      subject { described_class.new }

      it 'doesnt raise an error' do
        FakeFS do
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
          described_class.new.update_entry('workspace', 'test_workspace')
          described_class.new.update_entry('notes_folder', app)

          expect { subject.notes_folder }.to_not raise_error
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
            app = File.expand_path('..', __dir__)
            FakeFS::FileSystem.clone(app)
            FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
            described_class.new.update_entry('notes_folder', app)

            expect(subject).to receive(:create?).with('workspace')
            subject.switch('test_workspace')
          end
        end
      end

      context 'user confirmed' do
        it 'updates the workspace details' do
          FakeFS do
            allow(STDIN).to receive(:gets).and_return('y')
            app = File.expand_path('..', __dir__)
            FakeFS::FileSystem.clone(app)
            FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
            described_class.new.update_entry('notes_folder', app)

            expect(subject).to receive(:update_entry).with('workspace', 'test_workspace')
            subject.switch('test_workspace')
          end
        end
      end
    end
  end
end
