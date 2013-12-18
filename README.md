# LayerVault JS Client

NodeJS client for accessing the LayerVault API.

## Configuration

``` js
var LayerVault = require('layervault');

// Configure
var config = new LayerVault.Configuration(function () {
  this.oauthKey = 'abc123'
  this.oauthSecret = 'foobar'
  this.accessToken = 'sloths567' // optional, if you have it
});

// Create the client
var client = new LayerVault.Client(config);
```

## Usage

### Authentication

``` js
// If configured without an access token, you will need
// to authenticate and retrieve one. Here's the password flow:
client.auth.withPassword('username', 'password', function (err, accessToken) {
  // We are now logged in. The configuration is automatically updated
  // with the access token. We can store it somewhere permanent if needed.
});
```

### Retrieving Data

``` js
// We can retrieve information about the logged in user.
client.me(function (err, user) {
  console.log(user);

  // Get the user's primary organization
  var org = user.organizations[0];

  // Get the first project in the organization
  client.organization(org).project(org.projects[0]).get(function (err, project) {
    console.log(project);
  });
});
```