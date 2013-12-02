API = require './api.coffee'

module.exports = class Authenticate
  constructor: (@config) ->
    @tokenEndpoint = '/auth/token'
    @api = new API(@config)

  perform: (username, password, cb = ->) ->
    @api.post('/oauth/token',
      grant_type: 'password'
      username: username
      password: password
      client_id: @config.oauthKey
      client_secret: @config.oauthSecret
    , (error, resp, body) =>
      return cb(error, null) if error?

      @config.accessToken = resp.access_token
      cb(null, @config.accessToken)
    , {auth: false, excludeApiPath: true})
