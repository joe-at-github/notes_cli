class NoteCreator
  include Modules::ResourceUtils

  def initialize(notebook, title, note_path, workspace_path)
    @notebook = notebook
    @title = title.join('_')
    @note_path = note_path
    @workspace_path = workspace_path
  end

  def call
    return unless notebook_exists?(@notebook) || create?('notebook')
    
    handle_errors
    create_note
    notify
  end

  private

  def handle_errors
    raise ArgumentError, 'no notebook specified' if !@notebook || @notebook.empty?
    raise ArgumentError, 'no note title specified' if !@title || @title.empty?    
  end

  def create_note
    FileUtils.mkdir_p(@note_path)
    FileUtils.cd(@note_path)
    FileUtils.touch("#{@title}.md")
    FileUtils.cd(@workspace_path)
  end

  def notify
    puts File.basename(@workspace_path)
    puts '----------------'
    puts "Added '#{@title}' to your #{@notebook} notebook"
    puts File.join(@note_path, "#{@title}.md")
  end
end
