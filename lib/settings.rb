Configuration.for('settings') {
  epub {
    template_dir 'template/'
    output_dir 'output/'
    created_name 'tweet_favorite.epub'
  }

  # singup https://dev.twitter.com/apps
  twitter {
    account_name 'Your account name'
    consumer_key 'Your consumer_key'
    consumer_secret 'Your consumer_secret'
    oauth_token 'Your oauth_token'
    oauth_token_secret 'Your oauth_token_secret'
  }
}