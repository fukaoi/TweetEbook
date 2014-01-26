# -*- encoding: utf-8 -*-
require 'entities'

FactoryGirl.define do
  factory Entities::UserAccount do
    name 'tweet_ebook'
    profile_image 'https://pbs.twimg.com/profile_images/378800000175053038/fae8cf8c4fc0c047a739209cf8905d28.jpeg'
  end
end

FactoryGirl.define do
  factory Entities::Tweet do
    name 'tweet_ebook'
    favorites 1
    datetime '2014-01-25 19:13:00'
    article 'tweet ebook test'
    image 'https://pbs.twimg.com/profile_images/378800000175053038/fae8cf8c4fc0c047a739209cf8905d28.jpeg'
    desc ''
    images %w(
      https://pbs.twimg.com/profile_images/378800000175053038/fae8cf8c4fc0c047a739209cf8905d28.jpeg
    )
  end
end




