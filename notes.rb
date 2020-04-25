require './notes_manager.rb'
require 'optparse'

options = {}
manager = NotesManager.new

OptionParser.new do |opt|
  opt.on('-w --workspace WORKSPACE') { |option| manager.update('workspace', option) }
  opt.on('-n --notebook NOTEBOOK') { |option| manager.update('notebook', option) }
  opt.on('--notebooks') { |option| puts manager.list }
  opt.on('-l --list ANY_PATH_FROM_HEAD') { |option| manager.list(option) }
  opt.on('--head') { |option| puts manager.head }
end.parse!
