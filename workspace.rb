require 'pry'
require 'pry-byebug'
require 'yaml'
require 'fileutils'

class Workspace
  CONFIG_FILE = '/Users/joeffreylamy/Documents/notes/notes_cli/config.yml'

  def config
    YAML.load(File.read(CONFIG_FILE))
  end

  def create_note(title, notebook)
    raise 'no note notebook given' unless notebook
    full_dir_path = File.join(notes_folder, current, notebook)

    FileUtils.mkdir_p(full_dir_path)
    FileUtils.cd(full_dir_path)
    FileUtils.touch("#{title}.md")
    FileUtils.cd(File.join(notes_folder, current))

    puts "#{current}"
    puts "----------------"
    puts "Added '#{title}' to your #{notebook.join('/')} notebook"
  end

  def delete_note(title, notebook)
    raise 'no note notebook given' unless notebook
    full_dir_path = File.join(notes_folder, current, notebook)

    FileUtils.cd(full_dir_path)
    FileUtils.rm("#{title}.md")
    FileUtils.cd(File.join(notes_folder, current))

    puts "#{current}"
    puts "----------------"
    puts "Deleted '#{title}' to your #{notebook.join('/')} notebook"
  end

  def prompt_notes_folder_setup
    puts 'Which folder are you going to be storing your notes in?'
    puts 'please provide a full path e.g path/to/my/notes'
    folder =  STDIN.gets.chomp
    update_entry('notes_folder', folder)
  end

  def prompt_workspace_setup
    puts 'No workspace registered'
    puts 'Please provide the name of the workspace you like to add your note to'
    workspace =  STDIN.gets.chomp
    update_entry('workspace', workspace)
  end

  def current
    config['workspace']
  end

  def notes_folder
    return config['notes_folder'] if config && config['notes_folder']

    prompt_notes_folder_setup
  end

  def update_entry(key, value)
    current_config = config
    current_config ? current_config[key] = value.strip.chomp : current_config = { key => value }
    File.open(CONFIG_FILE, 'w') { |file| file.truncate(0) }
    File.open(CONFIG_FILE, 'r+') do |f|
      YAML.dump(current_config, f)
    end
  end
end
