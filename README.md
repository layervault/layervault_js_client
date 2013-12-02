# LayerVault JS Client

NodeJS client for accessing the LayerVault API.

## Usage

``` coffeescript
{Configuration, Client} = require('layervault')

# Configure
config = new Configuration ->
  @oauthKey = 'abc123'
  @oauthSecret = 'foobar'
  @accessToken = 'sloths567'

# Create the client
lv = new Client(config)

# If configured without an access token, you will need
# to authenticate and retrieve one.
lv.auth.perform 'username', 'password', ->

  # Perform an API call
  lv.getOrganization('layervault').then (org) ->
