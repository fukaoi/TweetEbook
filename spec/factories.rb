# -*- encoding: utf-8 -*-
require 'entities'

FactoryGirl.define do
  factory Entities::UserAccount do
    name 'tweet_ebook'
    profile_image 'https://si0.twimg.com/profile_images/378800000175053038/fae8cf8c4fc0c047a739209cf8905d28_bigger.jpeg'
  end
end

FactoryGirl.define do
  factory Entities::Tweet do
    name 'justinbieber'
    favorites 12
    datetime '2013-01-31 12:01:37'
    article 'Everyone having a good weekend?'
    image 'https://si0.twimg.com/profile_images/3467035972/4c978ba8510da3fb77d2d5e9ae7c93f0_normal.jpeg'
    desc '#BELIEVE is on ITUNES and in STORES WORLDWIDE! - SO MUCH LOVE FOR THE FANS...you are always there for me and I will always be there for you. MUCH LOVE. thanksAll Around The World · youtube.com/justinbieber'
    images %w(https://si0.twimg.com/profile_images/3467035972/4c978ba8510da3fb77d2d5e9ae7c93f0_normal.jpeg
      https://si0.twimg.com/profile_images/3467035972/4c978ba8510da3fb77d2d5e9ae7c93f0_normal.jpeg
      https://si0.twimg.com/profile_images/3467035972/4c978ba8510da3fb77d2d5e9ae7c93f0_normal.jpeg
    )
  end
end




