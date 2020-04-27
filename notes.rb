require_relative './workspace.rb'
require 'optparse'

workspace = Workspace.new

if ARGV.empty?
  ARGV << '--which_workspace'
  ARGV << 'any_character'
end

OptionParser.new do |opt|
  opt.on('-w --workspace WORKSPACE') do |option|
    puts "Switched to #{option} wokspace" if workspace.update_entry('workspace', option)
  end
  opt.on('--which_workspace ANY_CHARACTER') { |option| puts "Current workspace is #{workspace.current}" }
  opt.on('-n --new_note workspace TITLE PATH/TO/FILE') { |option| workspace.create_note(option, ARGV)}
end.parse!
