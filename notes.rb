require './workspace.rb'
require 'optparse'

options = {}
workspace = Workspace.new

OptionParser.new do |opt|
  opt.on('-s --set_workspace WORKSPACE') { |option| workspace.update_entry('workspace', option) }
  opt.on('-w --which_workspace ?') { |option| puts workspace.workspace }
  opt.on('-n --new_note workspace name') { |option| workspace.create_note(option, ARGV.first) }
end.parse!
