Configuration.for('settings') {
  epub {
    template_dir 'template/'
    output_dir 'output/'
    created_name 'tweet_favorite.epub'
  }

  # singup https://dev.twitter.com/apps
  twitter {
    account_name 'tweet_ebook'
    consumer_key 'NBB33GnifbkNLQMQym97A'
    consumer_secret '0zN3Iu4eGWx0dPsqnJ5TgESBn6ElDlJ3MO9QlGTAdY'
    access_token '1614801408-yCNXBNOWhsxV22ZhwGjGhaivXBKmHNKRoZn0JEd'
    access_token_secret 'M4MNXmz2b3IKxnuv8vBbkW2R8UYsEDzZlLdLSmbM'
  }
}