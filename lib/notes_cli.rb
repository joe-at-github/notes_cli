# frozen_string_literal: true

module NotesCli
  ROOTH_PATH = __dir__
  CONFIG_PATH = File.join(ROOTH_PATH, 'config.yml')
  LIBRARY = File.join(ROOTH_PATH, 'notes_cli')
end

require 'pry'
require 'pry-byebug'
require 'yaml'
require 'fileutils'
require 'optparse'
require File.join(NotesCli::LIBRARY, 'modules', 'modules.rb')
require File.join(NotesCli::LIBRARY, 'models', 'workspace.rb')
require File.join(NotesCli::LIBRARY, 'services', 'services.rb')
require File.join(NotesCli::LIBRARY, 'controllers', 'option_parser.rb')
