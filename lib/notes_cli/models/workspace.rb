# frozen_string_literal: true

class Workspace
  include Modules::ResourceUtils

  def initialize
    FileUtils.touch(NotesCli::CONFIG_PATH) unless File.file?(NotesCli::CONFIG_PATH)
  end

  def create_note(notebook, title)
    NoteCreator.new(notebook, title, notebook_path(notebook), workspace_path).call
  end

  def delete_note(notebook, title)
    NoteDeleter.new(notebook, title, notebook_path(notebook), workspace_path).call
  end

  def list_notes(notebook)
    NoteLister.new(notebook).call
  end

  def switch(workspace)
    return unless workspace_exists?(workspace) || create?('workspace')

    update_entry('workspace', workspace)
  end

  def update_entry(key, value)
    current_config = config
    current_config ? current_config[key] = value.strip.chomp : current_config = { key => value }
    File.open(NotesCli::CONFIG_PATH, 'w') { |file| file.truncate(0) }
    File.open(NotesCli::CONFIG_PATH, 'r+') do |f|
      YAML.dump(current_config, f)
    end
  end
end
