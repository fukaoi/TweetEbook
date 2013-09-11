require './lib/tweet_ebook'
require 'benchmark'

#require 'bundler'
#Bundler::GemHelper.install_tasks
#
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :generate

desc 'Generate epub file'
task :generate do
  puts Benchmark.measure {
    te = TweetEbook.new
    te.set_epub_build
  }
end
