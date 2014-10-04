APP_CONFIG = {
  gmail: {
    credentials_file: File.join(Rails.root, 'tmp/gmail_credentials'),
    username: 'beaverdash.receiver',
    password: 'beaverdashpass'
  },
  yo: {
    api_key: 'a5995080-2eac-799e-f3e1-f129038851c6'
  }
}

curl --data "api_token=a5995080-2eac-799e-f3e1-f129038851c6&link=http://mylink.com" http://api.justyo.co/yoall/