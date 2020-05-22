require 'pry'
require 'pry-byebug'
require 'yaml'
require 'fileutils'

class Workspace
  ROOTH_PATH = File.expand_path File.dirname(__FILE__)
  CONFIG_PATH = File.join(ROOTH_PATH, 'config.yml')

  def initialize
    FileUtils.touch(CONFIG_PATH) unless File.file?(CONFIG_PATH)    
  end

  def config
    YAML.load(File.read(CONFIG_PATH))
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

  def switch_workspace(workspace)
    unless exists?(workspace)
      puts "this workspace does not currently exist and will be created, do you wish to continue?"
      prompt = gets.chomp
      return if prompt != 'y'
    end

    update_entry('workspace', workspace)    
  end

  def exists?(workspace)
    full_dir_path = File.join(notes_folder, workspace)
    Dir.glob("#{notes_folder}/*/")
       .select { |entry| File.directory? entry }
       .map { |full_path| File.basename(full_path) }
       .include?(workspace)
  end

  def update_entry(key, value)
    current_config = config
    current_config ? current_config[key] = value.strip.chomp : current_config = { key => value }
    File.open(CONFIG_PATH, 'w') { |file| file.truncate(0) }
    File.open(CONFIG_PATH, 'r+') do |f|
      YAML.dump(current_config, f)
    end
  end
end
