namespace :events do
  desc "Fetch new events from the gmail account. "
  task fetch: :environment do
    require 'google/api_client'
    require 'google/api_client/client_secrets'
    require 'google/api_client/auth/installed_app'

    # Initialize the client.
    client = Google::APIClient.new(
      :application_name => 'BeaverDash',
      :application_version => '1.0.0'
    )

    client_secrets = Google::APIClient::ClientSecrets.load
    gm = client.discovered_api('gmail')
    client.authorization = client_secrets.to_authorization
    client.authorization.update_token!(YAML.load_file(APP_CONFIG[:gmail][:credentials_file]))

    result = client.execute(
      api_method: gm.users.messages.list,
      parameters: {
        userId: 'me',
      }
    )

    credentials = {}
    credentials[:access_token] = client.authorization.access_token
    credentials[:refresh_token] = client.authorization.refresh_token
    credentials[:expires_in] = client.authorization.expires_in
    credentials[:issued_at] = client.authorization.issued_at

    File.write(APP_CONFIG[:gmail][:credentials_file], credentials.to_yaml)

    count = 0
    result.data.messages.each do |m|
      count += 1
      message = client.execute(
        api_method: gm.users.messages.get,
        parameters: {
          userId: 'me',
          id: m.id
        }
      )

      subject = message.data.payload.headers.select do |h|
        h['name'] == 'Subject'
      end.first['value']

      content = message.data.payload.parts[0].body.data

      puts subject
      # puts message.data.to_json['payload']['parts']
      # puts message.data.to_json['payload']['parts'][0]
      # puts message.data.to_json['payload']['parts'][0]['body']
    end
  end

  task get_token: :environment do
    require 'google/api_client'
    require 'google/api_client/client_secrets'
    require 'google/api_client/auth/installed_app'

    # Initialize the client.
    client = Google::APIClient.new(
      :application_name => 'BeaverDash',
      :application_version => '1.0.0'
    )

    client_secrets = Google::APIClient::ClientSecrets.load

    gm = client.discovered_api('gmail')

    client.authorization = client_secrets.to_authorization
    client.authorization.scope = 'https://mail.google.com/'
    auth = client.authorization.dup
    auth.redirect_uri = 'http://127.0.0.1/oauth2callback'

    puts auth.authorization_uri.to_s

    flow = Google::APIClient::InstalledAppFlow.new(
      :client_id => client_secrets.client_id,
      :client_secret => client_secrets.client_secret,
      :scope => ['https://mail.google.com/']
    )

    auth.code = $stdin.gets.strip
    auth.fetch_access_token!

    credentials = {}
    credentials[:access_token] = auth.access_token
    credentials[:refresh_token] = auth.refresh_token
    credentials[:expires_in] = auth.expires_in
    credentials[:issued_at] = auth.issued_at

    if credentials[:refresh_token].nil?
      puts 'Failed due to empty refresh token. '
      return
    end

    File.write(APP_CONFIG[:gmail][:credentials_file], credentials.to_yaml)
    puts 'Success! '
  end

end
