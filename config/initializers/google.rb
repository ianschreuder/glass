# Initialize the client & Google+ API
require 'google/api_client'
$client = Google::APIClient.new

# Initialize OAuth 2.0 client    
$client.authorization.client_id = '<CLIENT_ID_FROM_API_CONSOLE>'
$client.authorization.client_secret = '<CLIENT_SECRET>'
$client.authorization.redirect_uri = '<YOUR_REDIRECT_URI>'
$client.authorization.scope = 'https://www.googleapis.com/auth/plus.me'

# Request authorization
redirect_uri = $client.authorization.authorization_uri

# Wait for authorization code then exchange for token
$client.authorization.code = '....'
$client.authorization.fetch_access_token!

# load API definitions
$plus = client.discovered_api('plus')
