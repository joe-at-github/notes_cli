# frozen_string_literal: true

workspace = Workspace.new

if ARGV.empty?
  ARGV << '--which_workspace'
  ARGV << 'any_character'
end

OptionParser.new do |opt|
  opt.on('-n --new_note NOTEBOOK NOTE_TITLE') { |option| workspace.create_note(option, ARGV) }

  opt.on('-d --delete_note NOTEBOOK NOTE_TITLE ') { |option| workspace.delete_note(option, ARGV) }

  opt.on('-l --list_notes NOTEBOOK NOTE_TITLE') do |option|
    workspace.list_notes(option)
  end

  opt.on('-w --workspace WORKSPACE') do |option|
    puts "Switched to #{option} wokspace" if workspace.switch(option)
  end 

  opt.on('--notes_folder PATH/TO/FOLDER') do |option|
    workspace.update_entry('notes_folder', option)
  end
 
  opt.on('--which_workspace ANY_CHARACTER') do |_option|
    puts "Current workspace is #{workspace.current_workspace}"
  end
end.parse!
