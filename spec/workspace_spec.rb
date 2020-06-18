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

  describe '#current' do
    context 'no workspace setup' do
      subject { described_class.new }

      it 'raises an error' do
        FakeFS do
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)

          expect { subject.current }.to raise_error(StandardError, 'Please set your workspace')
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

          expect { subject.current }.to_not raise_error
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

  describe 'creating notebooks' do
    subject { described_class.new }

    context 'confirmation' do
      it 'ask for creation confirmation' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('y')
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect(subject).to receive(:create?).with('notebook')
          subject.create_note('new_notebook', ['test_note'])
        end
      end
    end

    context 'user confirmed' do
      it 'creates the notebook' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('y')
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect { subject.create_note('new_notebook', ['test_note']) }
            .to change { File.directory?('new_notebook') }.from(false).to(true)
        end
      end
    end

    context 'user did not consent' do
      it 'does not create the notebook' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('n')
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect { subject.create_note('new_notebook', ['test_note']) }
            .to_not change { File.directory?('new_notebook') }
        end
      end
    end
  end

  describe 'deleting notes' do
    context 'note title not specified' do
      it 'raises an error' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('n')
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect { subject.delete_note('new_notebook', []) }
            .to raise_error(ArgumentError, 'no note title specified')
        end
      end
    end

    context 'notebook not specified' do
      it 'raises an error' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('n')
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')

          expect { subject.delete_note([], 'test_note') }
            .to raise_error(ArgumentError, 'no notebook specified')
        end
      end
    end

    context 'title and notebook specified' do
      it 'deletes the note' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('y')
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')
          described_class.new.create_note('new_notebook', ['test_note'])

          expect { subject.delete_note('new_notebook', ['test_note']) }
            .to change { File.file?('new_notebook/test_note.md') }.from(true).to(false)
        end
      end
    end
  end

  describe 'listing notes' do
    it 'list notes in the given notebook' do
      FakeFS do
        allow(STDIN).to receive(:gets).and_return('y')
        app = File.expand_path('..', __dir__)
        FakeFS::FileSystem.clone(app)
        FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
        described_class.new.update_entry('notes_folder', app)
        described_class.new.update_entry('workspace', 'test_workspace')
        described_class.new.create_note('new_notebook', ['test_note'])
        note_path = File.join('new_notebook', 'test_note.md')

        expect(subject.list_notes('new_notebook')).to include(note_path)
      end
    end

    context 'notebook does not exist' do
      it 'raises an error' do
        FakeFS do
          allow(STDIN).to receive(:gets).and_return('y')
          app = File.expand_path('..', __dir__)
          FakeFS::FileSystem.clone(app)
          FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
          described_class.new.update_entry('notes_folder', app)
          described_class.new.update_entry('workspace', 'test_workspace')
          described_class.new.create_note('new_notebook', ['test_note'])

          expect { subject.list_notes('not_here') }
            .to raise_error(StandardError, 'no such notebook')
        end
      end
    end
  end
end
