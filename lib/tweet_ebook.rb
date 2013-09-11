$LOAD_PATH.push(File.expand_path(File.dirname(__FILE__)))

require 'twitter'
require 'configuration'
require 'entities'
require 'epub_builder'
require 'contracts'
include Contracts

class TweetEbook
  RETURN_COUNTS = 500

  def initialize
    @conf = Configuration.for 'settings'
    setting
  end

  Contract NIL => ({:entities_obj => ArrayOf[Entities::Tweet], :profile_images => ArrayOf[String]})
  def get_favorites
    ents   = []
    images = []
    Twitter.favorites(count: RETURN_COUNTS).each do |res|
      ents << setting_tweet(res)
      images << res.profile_image_url
    end
    {entities_obj: ents, profile_images: images}
  end

  Contract NIL => Entities::UserAccount
  def get_user_account
    tw                 = Twitter.user
    user               = Entities::UserAccount.new
    user.name          = tw.name
    user.profile_image = tw.profile_image_url_https('original')
    user
  end

  Contract NIL => NIL
  def set_epub_build
    obj  = get_favorites
    epub = EpubBuilder.new(obj[:entities_obj], get_user_account, obj[:profile_images])
    epub.book
  end

  private
  Contract NIL => Twitter
  def setting
    Twitter.configure do |tw|
      tw.consumer_key       = @conf.twitter.consumer_key
      tw.consumer_secret    = @conf.twitter.consumer_secret
      tw.oauth_token        = @conf.twitter.oauth_token
      tw.oauth_token_secret = @conf.twitter.oauth_token_secret
    end
  end

  Contract Twitter::Tweet => Entities::Tweet
  def setting_tweet(twitter)
    ent           = Entities::Tweet.new
    ent.name      = twitter.from_user
    ent.datetime  = twitter.created_at
    ent.favorites = twitter.favorite_count
    ent.article   = twitter.text
    ent.desc      = twitter[:user][:description]
    ent.image     = twitter.profile_image_url
    ent
  end
end

