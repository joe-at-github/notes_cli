require 'pry'
require 'pry-byebug'
require 'yaml'

class Workspace
  CONFIG_FILE = 'config.yml'

  def config
    YAML.load(File.read(CONFIG_FILE))
  end

  def create_note(notebook, title)
    puts "#{current}"
    puts "----------------"
    puts "Added #{title} to your #{notebook} notebook"
  end
  # def notes_folder 
  #   config['notes_folder']
  # end

  def current
    config['workspace']
  end

  def update_entry(key, value)
    current_config = config
    current_config[key] = value.strip.chomp
    File.open(CONFIG_FILE, 'w') {|file| file.truncate(0) }
    File.open(CONFIG_FILE, 'r+') do |f|
      YAML.dump(current_config, f)
    end    
  end
end
