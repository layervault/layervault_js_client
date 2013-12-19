API = require './api.coffee'

# Handles API authentication and the related client configuration.
module.exports = class Authenticate
  # Constructs a new Authenticate object
  #
  # @param [Configuration] config The client configuration
  constructor: (@config) ->
    @tokenEndpoint = '/auth/token'
    @api = new API(@config)

  # Performs username/password authentication to retrieve OAuth tokens.
  #
  # @param [String] username The login username. For LayerVault this is the user's email address.
  # @param [String] paassword The login password.
  # @param [Function] cb The finished callback
  withPassword: (username, password, cb = ->) ->
    @api.post('/oauth/token',
      grant_type: 'password'
      username: username
      password: password
      client_id: @config.oauthKey
      client_secret: @config.oauthSecret
    , (error, resp, body) =>
      return cb(error, null) if error?

      @config.accessToken = resp.access_token
      @config.refreshToken = resp.refresh_token
      
      cb(null, @config.accessToken, @config.refreshToken)
    , {auth: false, excludeApiPath: true})
