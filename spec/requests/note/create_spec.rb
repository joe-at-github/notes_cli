# frozen_string_literal: true

require File.expand_path(File.join('..', '..', '..', 'lib', 'notes_cli'), __dir__)

RSpec.describe Workspace do
  def setup_workspace
    allow(STDIN).to receive(:gets).and_return('y')
    app = File.expand_path('../../../', __dir__)
    FakeFS::FileSystem.clone(app)
    FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
    described_class.new.update_entry('notes_folder', app)
    described_class.new.update_entry('workspace', 'test_workspace')
  end

  context 'note title not specified' do
    it 'raises an error' do
      FakeFS do
        setup_workspace

        expect { subject.create_note('new_notebook', []) }
          .to raise_error(ArgumentError, 'no note title specified')
      end
    end
  end

  context 'note title specified' do
    it 'returns a success notification' do
      FakeFS do
        setup_workspace
        success_notification = /Added 'new_note' to your new_notebook notebook/

        expect { subject.create_note('new_notebook', ['new', 'note']) }
          .to output(success_notification).to_stdout
      end
    end
  end
end
