# LayerVault JS Client

NodeJS client for accessing the [LayerVault API](https://developers.layervault.com).

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
client.auth.withPassword('username', 'password', function (err, accessToken, refreshToken) {
  // We are now logged in. The configuration is automatically updated
  // with the access token and refresh token. We can store them somewhere
  // persistent if needed.
});
```

### Retrieving Data

This API client uses a lightweight resource model to make getting associations very easy.

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

You can chain together objects to build a query. Responses are parsed to include proper object associations so you can continue to drill down data.

Arguments to the data types can be given as separate arguments (shown below), as path style ("Test/Stuff"), or a combination of both.

``` js
client.organization('layervault').folder('Test', 'Stuff').get(function (err, folder) {
  folder.files[0].revisions(function (err, revisions) {
    revisions[0].previews(function (err, urls) {
      console.log(urls);
    });
  });
});
```

### Uploading a File/Revision

Creating a new file and uploading a new revision are the same process. While it is a multi-step process, the API client takes care of most of the steps for you.

To upload a file, all you need to provide is the path to the file on disk and the mime-type of the file.

``` js
client.organization('layervault').file('Test/Stuff', 'NewFile.psd').create({
  localPath: "/path/to/file/on/disk/NewFile.psd",
  contentType: "image/vnd.adobe.photoshop"
}, function (err, resp) {
  console.log(resp);
});
```

### Promises

All asynchronous calls return a promise, which can be used as an alternative to providing a callback.

``` js
client.auth.withPassword('username', 'password', function(err, accessToken, refreshToken) {
  // Store tokens
}).then(function () {
  // Fetch 
  return client.organization('layervault').get();
}).then(function (org) {
  return org.projects[0].files[0].preview();
}).then(function (preview) {
  console.log(preview);
});
```

## Author

Ryan LeFevre - [GitHub](https://github.com/meltingice), [Twitter](https://twitter.com/meltingice), [Email](mailto:ryan@layervault.com)

## License

Available under the MIT license. See the LICENSE file for more info.