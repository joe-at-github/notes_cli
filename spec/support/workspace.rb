def create_workspace
  @app = File.expand_path('../../../', __dir__)
  FakeFS::FileSystem.clone(@app)
  FileUtils.rm(NotesCli::CONFIG_PATH) if File.file?(NotesCli::CONFIG_PATH)
  Workspace.new.update_entry('notes_folder', @app)
  Workspace.new.update_entry('workspace', 'test_workspace')
end