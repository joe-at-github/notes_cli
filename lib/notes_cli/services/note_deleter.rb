class NoteDeleter
  include Modules::ResourceUtils

  def initialize(notebook, title, notebook_path, workspace_path)
    @notebook = notebook
    @title = title.join('_')
    @notebook_path = notebook_path
    @workspace_path = workspace_path
  end

  def call
    handle_errors
    delete_note
    notify
  end

  private

  def handle_errors
    raise ArgumentError, 'no notebook specified' if !@notebook || @notebook.empty?
    raise ArgumentError, 'no note title specified' if !@title || @title.empty?
    raise ArgumentError, 'notebook does not exist' unless notebook_exists?(@notebook)
  end

  def delete_note 
    FileUtils.cd(@notebook_path)
    FileUtils.rm("#{@title}.md")
    FileUtils.cd(@workspace_path)
  end

  def notify
    puts current_workspace.to_s
    puts '----------------'
    puts "Deleted '#{@title}' from your #{@notebook} notebook"
  end
end
