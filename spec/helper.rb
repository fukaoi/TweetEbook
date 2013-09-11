puts $:

require 'rspec'
require 'rspec-expectations'
require 'configuration'
require 'factory_girl'
require 'factories'

RSpec.configure do |conf|

  conf.include FactoryGirl::Syntax::Methods

  conf.before(:all) do
    FileUtils.mkdir getOutputDir if !File.exist? getOutputDir
    disp'created test directory'
  end

  conf.after(:all) do
    FileUtils.remove_dir getOutputDir if File.exist? getOutputDir
    disp 'deleted test directory'
  end
end

def getOutputDir
  sett = Configuration.for 'settings'
  sett.epub.output_dir
end

def disp(mess)
  puts "[helper]#{mess}"
end

def helper_create_oebps_dir
  require 'epub_parts'
  parts = EpubParts.new
  parts.create_oebps_dir?
end

def helper_create_all
  require 'epub_parts'
  parts = EpubParts.new
  parts.create_oebps_dir?
  parts.create_meta_dir?
  parts.create_mimefile?
end

def xml_regex_format
  /<\?xml version="1.0" encoding="utf-8" \?>(.*)+/
end

def manifest_regex_format
  /<package prefix=\"rendition:(.*)+/
end


