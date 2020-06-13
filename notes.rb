# frozen_string_literal: true

require_relative './workspace.rb'
require 'optparse'

workspace = Workspace.new

if ARGV.empty?
  ARGV << '--which_workspace'
  ARGV << 'any_character'
end

OptionParser.new do |opt|
  opt.on('-d --delete_note TITLE PATH/TO/FILE ') { |option| workspace.delete_note(option, ARGV) }
  opt.on('-n --new_note TITLE PATH/TO/FILE') { |option| workspace.create_note(option, ARGV) }
  opt.on('-l --list TITLE PATH/TO/NOTEBOOK') { |option| puts workspace.list_notes(option) }
  opt.on('--notes_folder PATH/TO/FOLDER') do |option|
    workspace.update_entry('notes_folder', option)
  end
  opt.on('-w --workspace WORKSPACE') do |option|
    puts "Switched to #{option} wokspace" if workspace.switch_workspace(option)
  end
  opt.on('--which_workspace ANY_CHARACTER') do |_option|
    puts "Current workspace is #{workspace.current}"
  end
end.parse!
