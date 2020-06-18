class NoteCreator
  include Modules::ResourceUtils

  def initialize(notebook, title, notebook_path, workspace_path)
    @notebook = notebook
    @title = title.join('_')
    @notebook_path = notebook_path
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
    FileUtils.mkdir_p(@notebook_path)
    FileUtils.cd(@notebook_path)
    FileUtils.touch("#{@title}.md")
    FileUtils.cd(@workspace_path)
  end

  def notify
    puts File.basename(@workspace_path)
    puts '----------------'
    puts "Added '#{@title}' to your #{@notebook} notebook"
    puts File.join(@notebook_path, "#{@title}.md")
  end
end
