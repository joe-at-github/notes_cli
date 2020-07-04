lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'notes_cli/version'

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
  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.executables << 'notes'
  s.require_paths = ['lib']
  s.homepage    =
    'https://github.com/joe-at-github/notes_cli'
  s.license       = 'MIT'
  s.add_development_dependency 'fakefs', '~> 0.5'
  s.add_development_dependency 'pry', '~> 0.12'
  s.add_development_dependency 'pry-byebug', '~> 3.9'
  s.add_development_dependency 'rspec', '~> 3.9'
  s.add_development_dependency 'rubocop', '~> 0.86'
  s.add_development_dependency 'simplecov', '~> 0.18'
end