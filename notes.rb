require './workspace.rb'
require 'optparse'

options = {}
workspace = Workspace.new

OptionParser.new do |opt|
  opt.on('-s --set_workspace WORKSPACE') { |option| workspace.update_entry('workspace', option) }
  opt.on('-w --which_workspace ANY_CHARACTER') { |option| puts workspace.current }
  opt.on('-n --new_note workspace TITLE PATH/TO/FILE') { |option| workspace.create_note(option, ARGV) }
end.parse!
