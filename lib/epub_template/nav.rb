require 'epub_template'
require 'contracts'
include Contracts

module EpubTemplate
  class Nav < EpubTemplate::Base
    CREATE_FILE = 'nav.html'
    def initialize
      super
      @nav = load 'nav.slim'
    end

    Contract ArrayOf[Entities::Tweet] => String
    def render(tweet_obj)
      modify_tweet_obj = group_year_month(tweet_obj)
      @html = super(@nav, modify_tweet_obj)
    end

    Contract NIL => Bool
    def create
      raise EpubError, 'Not found @html' unless @html
      super(@html, CREATE_FILE)
      raise EpubError, 'Failed makeing of the html file' unless exist?(CREATE_FILE)
      true
    end

    private
    Contract ArrayOf[Entities::Tweet] => {}
    def group_year_month(datetime)
      dates = {}; tmp_date = ''; i = 0
      files = pages_file_name
      raise EpubError, 'No file pages*.html' unless files.any?
      datetime.each do |d|
        /([0-9]{4}-[0-9]{2})/ =~ d.datetime.to_s
        dates.store($1, files[i/2]) if (tmp_date != $1)
        tmp_date = $1
        i += 1
      end
      dates
    end
  end
end