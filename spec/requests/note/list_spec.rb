# frozen_string_literal: true

require File.expand_path(File.join('..', '..', '..', 'lib', 'notes_cli'), __dir__)

RSpec.describe 'listing notes' do
  subject { Workspace.new.list_notes('new_notebook') }

  it 'lists notes in the given notebook' do
    FakeFS do
      allow(STDIN).to receive(:gets).and_return('y')
      create_workspace
      Workspace.new.create_note('new_notebook', ['test_note'])
      note_path = File.join('new_notebook', 'test_note.md')
      expectation = { 'test_note.md' => note_path }

      expect(subject).to eq(expectation)
    end
  end
 
  context 'notebook is empty' do
    it 'notifies user' do
      FakeFS do
        allow(STDIN).to receive(:gets).and_return('y')
        create_workspace
        Workspace.new.create_note('new_notebook', ['test_note'])
        Workspace.new.delete_note('new_notebook', ['test_note'])
        notification = /new_notebook is empty/

        expect { subject }.to output(notification).to_stdout
      end
    end
  end
 
  context 'notebook does not exist' do
    subject { Workspace.new.list_notes('not_here') }

    it 'raises an error' do
      FakeFS do
        allow(STDIN).to receive(:gets).and_return('y')
        create_workspace
        Workspace.new.create_note('new_notebook', ['test_note'])

        expect { subject }.to raise_error(StandardError, 'no such notebook')
      end
    end
  end
end
