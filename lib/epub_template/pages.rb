require 'epub_template'
require 'contracts'
include Contracts

module EpubTemplate
  class Pages < EpubTemplate::Base
    CREATE_FILE = 'pages.html'

    def initialize
      super
      @pages = load 'pages.slim'
    end

    Contract ArrayOf[Entities::Tweet] => ArrayOf[String]
    def render(tweet_obj)
      i = 0
      @html = []
      while i < tweet_obj.length
        @html << super(@pages, tweet_obj.slice(i, 2))
        i += 2
      end
      @html
    end

    Contract NIL => Bool
    def create
      raise EpubError, 'Not found @html' unless @html
      i = 1
      @html.each do |tweet|
        page = "pages#{i}.html"
        super(tweet, page)
        raise EpubError, 'Failed makeing of the html file' unless exist?(page)
        i += 1
      end
      true
    end
  end
end