require 'rubygems'
require 'bundler'
Bundler.require

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new("spec") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec

task :build_docs do |t|
  sh "docco -c docs.css -o . USAGE.rb.md"
  sh "rm index.html" rescue nil
  sh "mv USAGE.rb.html index.html"
  sh "git add ."
  sh "git commit -m 'Build docs'"
end
