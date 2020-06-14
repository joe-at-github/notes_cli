# frozen_string_literal: true

require 'pry'
require 'pry-byebug'
require 'yaml'
require 'fileutils'
require_relative 'lib/note_creator.rb'

class Workspace
  ROOTH_PATH = __dir__
  CONFIG_PATH = File.join(ROOTH_PATH, 'config.yml')

  def initialize
    FileUtils.touch(CONFIG_PATH) unless File.file?(CONFIG_PATH)
  end

  def config
    YAML.safe_load(File.read(CONFIG_PATH))
  end

  def create_note(notebook, title)
    return unless notebook_exists?(notebook) || create?('notebook')

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


  def note_path(notebook)
    @note_path ||= File.join(notes_folder, current, notebook)
  end

  def workspace_path
    File.join(notes_folder, current)
  end

  def notes_folder
    return config['notes_folder'] if config && config['notes_folder']

    raise StandardError, 'Please set your notes_folder'
  end

  def current
    return config['workspace'] if config && config['workspace']

    raise StandardError, 'Please set your workspace'
  end

  def switch_workspace(workspace)
    return unless workspace_exists?(workspace) || create?('workspace')

    update_entry('workspace', workspace)
  end

  def workspace_exists?(workspace)
    Dir.glob(File.join(notes_folder, workspace)).any?
  end

  def notebook_exists?(notebook)
    Dir.glob(File.join(notes_folder, current, notebook)).any?
 end

  def create?(resource)
    puts "This #{resource} does not currently exist and will be created, "\
         'do you wish to continue? [y/N]'
    STDIN.gets.chomp == 'y'
  end

  def update_entry(key, value)
    current_config = config
    current_config ? current_config[key] = value.strip.chomp : current_config = { key => value }
    File.open(CONFIG_PATH, 'w') { |file| file.truncate(0) }
    File.open(CONFIG_PATH, 'r+') do |f|
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
