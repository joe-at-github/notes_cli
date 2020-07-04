# frozen_string_literal: true

require File.expand_path(File.join('..', '..', '..', 'lib', 'notes_cli'), __dir__)

RSpec.describe 'creating notes' do
  context 'notebook exists' do
    subject { Workspace.new }

    def create_notebook
      FileUtils.mkdir_p(File.join(@app, 'test_workspace', 'new_notebook'))
    end

    context 'note title not specified' do
      it 'raises an error' do
        FakeFS.with_fresh do
          create_workspace
          create_notebook

          expect { subject.create_note('new_notebook', []) }
            .to raise_error(ArgumentError, 'no note title specified')
        end
      end
    end

    context 'note title specified' do
      it 'returns a success notification' do
        FakeFS.with_fresh do
          create_workspace
          create_notebook
          success_notification = /Added 'new_note' to your new_notebook notebook/

          expect { subject.create_note('new_notebook', %w[new note]) }
            .to output(success_notification).to_stdout
        end
      end
    end
  end

  context 'notebook does not exist' do
    subject { Workspace.new.create_note('new_notebook', %w[new note]) }

    context 'prompt' do
      it 'asks user confirmation to create the notebook' do
        FakeFS.with_fresh do
          create_workspace
          allow(STDIN).to receive(:gets).and_return('y')
          confirmation_prompt = /This notebook does not currently exist and will be created/

          expect { subject }.to output(confirmation_prompt).to_stdout
        end
      end
    end

    context 'user confirms' do
      it 'creates the notebook' do
        FakeFS.with_fresh do
          create_workspace
          allow(STDIN).to receive(:gets).and_return('y')

          expect { subject }.to change { File.directory?('new_notebook') }.from(false).to(true)
        end
      end
    end

    context 'user does not consent' do
      it 'does not create the notebook' do
        FakeFS.with_fresh do
          create_workspace
          allow(STDIN).to receive(:gets).and_return('n')

          expect { subject }.to_not change { File.directory?('new_notebook') }
        end
      end
    end
  end
end
