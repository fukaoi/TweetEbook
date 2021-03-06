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
    @tw_client = setting
  end

  Contract NIL => NIL
  def set_epub_build
    obj  = get_favorites
    epub = EpubBuilder.new(obj[:entities_obj], get_owner_account, obj[:profile_images])
    epub.book
  end

  private
  Contract NIL => ({:entities_obj => ArrayOf[Entities::Tweet], :profile_images => ArrayOf[String]})
  def get_favorites
    ents   = []; images = []
    @tw_client.favorites(count: RETURN_COUNTS).each do |res|
      ents << setting_tweet(res)
      images << res.user.profile_image_url.to_s
    end
    {entities_obj: ents, profile_images: images}
  end

  Contract NIL => Entities::UserAccount
  def get_owner_account
    user               = Entities::UserAccount.new
    user.name          = @tw_client.user.name
    user.profile_image = @tw_client.user.profile_image_url_https('original').to_s
    user
  end

  #Contract NIL => Twitter
  def setting
    Twitter::REST::Client.new do |tw|
      tw.consumer_key       = @conf.twitter.consumer_key
      tw.consumer_secret    = @conf.twitter.consumer_secret
      tw.access_token        = @conf.twitter.access_token
      tw.access_token_secret = @conf.twitter.access_token_secret
    end
  end

  Contract Twitter::Tweet => Entities::Tweet
  def setting_tweet(twitter)
    ent           = Entities::Tweet.new
    ent.name      = twitter.user.name
    ent.datetime  = twitter.created_at
    ent.favorites = twitter.favorite_count
    ent.article   = twitter.text
    ent.desc      = twitter.user.description
    ent.image     = twitter.user.profile_image_url.to_s
    ent
  end
end

