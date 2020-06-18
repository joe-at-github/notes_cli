# frozen_string_literal: true

workspace = Workspace.new

if ARGV.empty?
  ARGV << '--which_workspace'
  ARGV << 'any_character'
end

OptionParser.new do |opt|
  opt.on('-d --delete_note TITLE PATH/TO/FILE ') { |option| workspace.delete_note(option, ARGV) }
  opt.on('-n --new_note TITLE PATH/TO/FILE') { |option| workspace.create_note(option, ARGV) }
  opt.on('-l --list_notes TITLE PATH/TO/NOTEBOOK') do |option|
    entries = workspace.list_notes(option)
    max_spacing = entries.keys.max_by(&:length).size
    entries.each do |k, v|
      spacing = ' ' * (max_spacing - k.length)
      puts "#{k} #{spacing} #{v}"
    end
  end
  opt.on('--notes_folder PATH/TO/FOLDER') do |option|
    workspace.update_entry('notes_folder', option)
  end
  opt.on('-w --workspace WORKSPACE') do |option|
    puts "Switched to #{option} wokspace" if workspace.switch(option)
  end
  opt.on('--which_workspace ANY_CHARACTER') do |_option|
    puts "Current workspace is #{workspace.current_workspace}"
  end
end.parse!
