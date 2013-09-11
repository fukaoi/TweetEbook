require 'epub_error'

module Entities
  class Tweet
    attr_accessor :name,
                  :datetime,
                  :article,
                  :desc,
                  :image,
                  :favorites,
                  :images

    def image_name
      raise EpubError, puts(self) unless self.image
      File.basename self.image
    end
  end

  class UserAccount
    attr_accessor :name,
                  :profile_image
  end

  class Manifest
    attr_accessor :page_names,
                  :created_date,
                  :images,
                  :name,
                  :uuid
  end
end