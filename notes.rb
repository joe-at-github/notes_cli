require_relative './workspace.rb'
require 'optparse'

workspace = Workspace.new

if ARGV.empty?
  ARGV << '--which_workspace'
  ARGV << 'any_character'
end

OptionParser.new do |opt|
  opt.on('--set_notes_folder') do |option|
    puts 'Which folder are you going to be storing your notes in?'
    puts 'please provide a full path e.g path/to/my/notes'
    workspace.prompt_notes_folder_setup
  end
  opt.on('-w --workspace WORKSPACE') do |option|
    puts "Switched to #{option} wokspace" if workspace.update_entry('workspace', option)
  end
  opt.on('--which_workspace ANY_CHARACTER') { |option| puts "Current workspace is #{workspace.current}" }
  opt.on('-n --new_note workspace TITLE PATH/TO/FILE') { |option| workspace.create_note(option, ARGV) }
end.parse!
