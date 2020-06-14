# frozen_string_literal: true

module NotesCli
  ROOTH_PATH = __dir__
  CONFIG_PATH = File.join(ROOTH_PATH, 'config.yml')
end

require 'pry'
require 'pry-byebug'
require 'yaml'
require 'fileutils'
require 'optparse'
require File.join(NotesCli::ROOTH_PATH, 'notes_cli', 'modules', 'modules.rb')
require File.join(NotesCli::ROOTH_PATH, 'notes_cli', 'models', 'workspace.rb')
require File.join(NotesCli::ROOTH_PATH, 'notes_cli', 'services', 'note_creator.rb')
require File.join(NotesCli::ROOTH_PATH, 'notes_cli', 'controllers', 'option_parser.rb')
