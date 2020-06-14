# frozen_string_literal: true

class Workspace
  include Modules::ResourceUtils

  def initialize
    FileUtils.touch(NotesCli::CONFIG_PATH) unless File.file?(NotesCli::CONFIG_PATH)
  end

  def create_note(notebook, title)
    NoteCreator.new(notebook, title, note_path(notebook), workspace_path).call
  end

  def delete_note(notebook, title)
    raise ArgumentError, 'no notebook specified' if !notebook || notebook.empty?
    raise ArgumentError, 'no note title specified' if !title || title.compact.empty?

    title = title.join('_')
    FileUtils.cd(note_path(notebook))
    FileUtils.rm("#{title}.md")
    FileUtils.cd(File.join(notes_folder, current))

    puts current.to_s
    puts '----------------'
    puts "Deleted '#{title}' from your #{notebook} notebook"
  end

  def switch_workspace(workspace)
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

  def list_notes(notebook)
    raise StandardError, 'no such notebook' unless notebook_exists?(notebook)

    {}.tap do |entries|
      Dir.glob(File.join(notes_folder, current, notebook, '/*')).sort.each do |path|
        entries[File.basename(path)] = path
      end
    end
  end
end
