require 'pry'
require 'yaml'
require 'yaml/dbm'

class NotesManager
  # Helps you move around your notes
  CONFIG_FILE = 'config.yml'

  def config
    YAML.load(File.read(CONFIG_FILE))
  end

  def head
    [notes_folder, workspace].join('/')
  end

  def notes_folder 
    config['notes_folder']
  end

  def workspace
    config['workspace']
  end

  def notebook
    config['notebook']
  end

  def list(notebook = '')
    Dir[File.join(head, notebook, '/*')].each do |file_path|
      puts
      puts "#{File.basename(file_path)}" 
      puts file_path
      puts '________________________________________'
    end
  end

  def update(key, value)
    current_config = config
    current_config[key] = value.strip.chomp
    File.open(CONFIG_FILE, 'w') {|file| file.truncate(0) }
    File.open(CONFIG_FILE, 'r+') do |f|
      YAML.dump(current_config, f)
    end    
  end
end
