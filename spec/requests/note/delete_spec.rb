# frozen_string_literal: true

require File.expand_path(File.join('..', '..', '..', 'lib', 'notes_cli'), __dir__)

RSpec.describe 'deleting notes' do
  subject { Workspace.new }

  def create_workspace
    @app = File.expand_path('../../../', __dir__)
    FakeFS::FileSystem.clone(@app)
    FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
    subject.update_entry('notes_folder', @app)
    subject.update_entry('workspace', 'test_workspace')
  end

  context 'title and notebook specified' do
    context 'notebook exists' do
      it 'deletes the note' do
        FakeFS.with_fresh do
          create_workspace
          allow(STDIN).to receive(:gets).and_return('y')
          subject.create_note('new_notebook', ['test_note'])

          expect { subject.delete_note('new_notebook', %w[test note]) }
            .to change { File.file?('new_notebook/test_note.md') }.from(true).to(false)
        end
      end
    end

    context 'notebook does not exist' do
      it 'raises an error' do
        FakeFS.with_fresh do
          create_workspace
          allow(STDIN).to receive(:gets).and_return('n')

          expect { subject.delete_note('invalid_notebook', %w[test note]) }
            .to raise_error(ArgumentError, 'notebook does not exist')
        end
      end
    end
  end

  context 'note title not specified' do
    it 'raises an error' do
      FakeFS.with_fresh do
        create_workspace
        allow(STDIN).to receive(:gets).and_return('n')

        expect { subject.delete_note('new_notebook', []) }
          .to raise_error(ArgumentError, 'no note title specified')
      end
    end
  end

  context 'notebook not specified' do
    it 'raises an error' do
      FakeFS.with_fresh do
        create_workspace
        allow(STDIN).to receive(:gets).and_return('n')

        expect { subject.delete_note('', %w[test note]) }
          .to raise_error(ArgumentError, 'no notebook specified')
      end
    end
  end
end
