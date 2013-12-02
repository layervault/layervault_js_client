# LayerVault JS Client

NodeJS client for accessing the LayerVault API.

## Usage

``` coffeescript
LayerVault = require('layervault')

# Configure
config = new LayerVault.Configuration ->
  @oauthKey = 'abc123'
  @oauthSecret = 'foobar'
  @accessToken = 'sloths567' # optional

# Create the client
client = new LayerVault.Client(config)

# If configured without an access token, you will need
# to authenticate and retrieve one. Here's the password flow:
client.auth.withPassword 'username', 'password', (err, resp) ->
  client.me (err, user) ->
    console.log user
    org = user.organizations[0]

    client.organization(org).node org.projects[0], (err, node) ->
      console.log node.path
```