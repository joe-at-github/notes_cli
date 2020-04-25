require_relative './workspace.rb'
require 'optparse'

options = {}
workspace = Workspace.new

OptionParser.new do |opt|
  opt.on('-s --set_workspace WORKSPACE') do |option| 
    puts "Switched to #{option} wokspace" if workspace.update_entry('workspace', option) 
  end
  opt.on('-w --which_workspace ANY_CHARACTER') { |option| puts "Current workspace is #{workspace.current}" }
  opt.on('-n --new_note workspace TITLE PATH/TO/FILE') { |option| workspace.create_note(option, ARGV)}
end.parse!
