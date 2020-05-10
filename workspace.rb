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

  def current
    return config['workspace'] if config && config['workspace']

    raise 'please set your workspace'
  end

  def notes_folder
    return config['notes_folder'] if config && config['notes_folder']

    raise 'please set your notes_folder'
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
