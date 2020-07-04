Gem::Specification.new do |s|
  s.name        = 'notes_cli'
  s.version     = '0.0.0'
  s.date        = '2020-07-04'
  s.summary     = 'Easy note taking from the command line'
  s.description = 'A simple hello world gem'
  s.authors     = ['Joe Lamy']
  s.email       = 'joeffreylamy41@gmail.com'
  s.files       = ['lib/notes_cli.rb']
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