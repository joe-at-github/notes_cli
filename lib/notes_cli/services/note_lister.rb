# frozen_string_literal: true

class NoteLister
  include Modules::ResourceUtils
  
  def initialize(notebook)
    @notebook = notebook
  end

  def call
    handle_errors
    return list if entries.any?

    empty_notebook_notification
  end

  private

  def handle_errors
    raise StandardError, 'no such notebook' unless notebook_exists?(@notebook)
  end

  def list
    max_spacing = entries.keys.max_by(&:length).size
    entries.each do |k, v|
      spacing = ' ' * (max_spacing - k.length)
      puts "#{k} #{spacing} #{v}"
    end
  end

  def entries
    @entries ||= {}.tap do |entries|
      Dir.glob(File.join(notes_folder, current_workspace, @notebook, '/*')).sort.each do |path|
        entries[File.basename(path)] = path
      end
    end
  end

  def empty_notebook_notification
    puts File.basename(current_workspace)
    puts '----------------'
    puts "#{@notebook} is empty"
  end
end
