API = require './api.coffee'

module.exports = class Authenticate
  constructor: (@config) ->
    @tokenEndpoint = '/auth/token'
    @api = new API(@config)

  withPassword: (username, password, cb = ->) ->
    @api.post('/oauth/token',
      grant_type: 'password'
      username: username
      password: password
      client_id: @config.oauthKey
      client_secret: @config.oauthSecret
    , (error, resp, body) =>
      return cb(error, null) if error?
      console.log resp

      @config.accessToken = resp.access_token
      @config.refreshToken = resp.refresh_token
      
      cb(null, @config.accessToken, @config.refreshToken)
    , {auth: false, excludeApiPath: true})
