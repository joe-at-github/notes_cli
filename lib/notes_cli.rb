# frozen_string_literal: true

module NotesCli
  ROOTH_PATH = __dir__
  LIBRARY = File.join(ROOTH_PATH, 'notes_cli')
  CONFIG_PATH = File.join(LIBRARY, 'config.yml')
end

require 'yaml'
require 'fileutils'
require 'optparse'
require File.join(NotesCli::LIBRARY, 'modules', 'modules')
require File.join(NotesCli::LIBRARY, 'models', 'workspace')
require File.join(NotesCli::LIBRARY, 'services', 'services')
require File.join(NotesCli::LIBRARY, 'controllers', 'option_parser')
require File.join(NotesCli::LIBRARY, 'version')
