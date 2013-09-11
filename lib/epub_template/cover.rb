require 'epub_template'
require 'epub_parts'
require 'contracts'
include Contracts

module EpubTemplate
  class Cover < EpubTemplate::Base
    CREATE_FILE = 'cover.html'

    def initialize
      super
      @cover = load 'cover.slim'
    end

    Contract Entities::UserAccount => String
    def render(user_account)
      EpubParts.new.save_images?([user_account.profile_image])
      user_account.profile_image = File.basename(user_account.profile_image)
      @html = super(@cover, user_account)
    end

    Contract NIL => Bool
    def create
      raise EpubError, 'Not found @html' unless @html
      super(@html, CREATE_FILE)
      raise EpubError, 'Failed makeing of the html file' unless exist?(CREATE_FILE)
      true
    end
  end
end