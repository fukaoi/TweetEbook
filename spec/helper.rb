puts $:

require 'rspec'
require 'rspec-expectations'
require 'configuration'
require 'factory_girl'
require 'factories'

RSpec.configure do |conf|

  conf.include FactoryGirl::Syntax::Methods

  conf.before(:all) do
    unless File.exist? getOutputDir
      helper_create_all
      disp'created test directory'
    end
  end

  conf.after(:all) do
    if File.exist? getOutputDir
      FileUtils.remove_dir getOutputDir
      disp 'deleted test directory'
    end
  end
end

def getOutputDir
  sett = Configuration.for 'settings'
  sett.epub.output_dir
end

def disp(mess)
  puts "[helper]#{mess}"
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


