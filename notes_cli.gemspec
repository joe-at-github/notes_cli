require File.expand_path('../lib/notes_cli/version', __FILE__)


Gem::Specification.new do |s|
  s.name        = 'notes_cli'
  s.version     = NotesCli::VERSION
  s.date        = '2020-07-04'
  s.summary     = 'Easy note management from the command line'
  s.description = %q{
    Easily create, delete and list all your notes.
    NotesCli lets you create workspaces and notebooks in which you can store notes.
    Notes are created as md files for ease of storing code snippets.
  }.strip.gsub(/\s+/, ' ')
  s.authors     = ['Joeffrey Lamy']
  s.email       = 'joeffreylamy41@gmail.com'
  s.files       = ['lib/notes_cli.rb']
  s.executables << 'notes'
  s.homepage    =
    'https://rubygems.org/gems/notes_cli'
  s.license       = 'MIT'

  s.add_development_dependency 'fakefs'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
end