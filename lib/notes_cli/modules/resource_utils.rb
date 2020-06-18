# frozen_string_literal: true

module Modules
  module ResourceUtils
    def config
      YAML.safe_load(File.read(NotesCli::CONFIG_PATH))
    end

    def notebook_exists?(notebook)
      Dir.exist?(File.join(notes_folder, current_workspace, notebook))
    end

    def workspace_exists?(workspace)
      Dir.exist?(File.join(notes_folder, workspace))
    end

    def create?(resource)
      puts "This #{resource} does not currently exist and will be created, "\
           'do you wish to continue? [y/N]'
      STDIN.gets.chomp == 'y'
    end

    def current_workspace
      return config['workspace'] if config && config['workspace']

      raise StandardError, 'Please set your workspace'
    end

    def notes_folder
      return config['notes_folder'] if config && config['notes_folder']

      raise StandardError, 'Please set your notes_folder'
    end

    def notebook_path(notebook)
      @notebook_path ||= File.join(notes_folder, current_workspace, notebook)
    end

    def workspace_path
      File.join(notes_folder, current_workspace)
    end
  end
end
