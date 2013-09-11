require 'epub_template/cover'
require 'epub_template/manifest'
require 'epub_template/nav'
require 'epub_template/pages'
require 'epub_parts'
require 'entities'
require 'epub_error'
require 'contracts'
include Contracts

class EpubBuilder
  Contract ArrayOf[Entities::Tweet], Entities::UserAccount, ArrayOf[String] => NIL
  def initialize(tweet_obj, user_account_obj, images)
    @tweet_obj = tweet_obj
    @account_obj = user_account_obj
    @images = images
    return
  end

  def book
    directory
    finish('directory')
    page
    finish('page')
    cover
    finish('cover')
    nav
    finish('nav')
    manifest
    finish('manifest')
    archive
    finish('Your TweetBook create ')
  end

  private
  def directory
    pr = EpubParts.new
    pr.create_meta_dir?
    pr.create_oebps_dir?
    pr.create_mimefile?
    pr.save_images?(@images)
  end

  def page
    pg = EpubTemplate::Pages.new
    pg.render(@tweet_obj)
    pg.create
  end

  def cover
    cr = EpubTemplate::Cover.new
    cr.render(@account_obj)
    cr.create
  end

  def nav
    nv = EpubTemplate::Nav.new
    nv.render(@tweet_obj)
    nv.create
  end

  def manifest
    mf = EpubTemplate::Manifest.new
    mf.render(@account_obj.name)
    mf.create
  end

  def archive
    pr = EpubParts.new
    pr.create_epub?
  end

  def finish(mess)
    puts "#{mess} finished..."
  end
end


