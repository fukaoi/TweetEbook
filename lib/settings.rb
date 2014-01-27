Configuration.for('settings') {
  epub {
    template_dir 'template/'
    output_dir 'output/'
    created_name 'tweet_ebook.epub'
  }

  # singup https://dev.twitter.com/apps
  twitter {
    account_name 'Your account name'
    consumer_key 'Your consumer_key'
    consumer_secret 'Your consumer_secret'
    access_token 'Your access_token'
    access_token_secret 'Your access_token_secret'
  }
}
