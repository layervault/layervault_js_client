RSVP    = require 'rsvp'
needle  = require 'needle'

# Handles API authentication and the related client configuration.
module.exports = class Authenticate
  # Constructs a new Authenticate object
  #
  # @param [Configuration] config The client configuration
  constructor: (@config) ->
    @tokenEndpoint = @config.apiBase + '/oauth/token'

  # Performs username/password authentication to retrieve OAuth tokens.
  #
  # @param [String] username The login username. For LayerVault this is the user's email address.
  # @param [String] paassword The login password.
  # @param [Function] cb The finished callback
  withPassword: (username, password, cb = ->) ->
    new RSVP.Promise (resolve, reject) =>
      needle.post @tokenEndpoint,
        grant_type: 'password'
        username: username
        password: password
        client_id: @config.oauthKey
        client_secret: @config.oauthSecret
      , (error, resp, body) =>
        if error?
          reject(error)
          cb(error, null)
          return

        @config.accessToken = body.access_token
        @config.refreshToken = body.refresh_token
        data = accessToken: @config.accessToken, refreshToken: @config.refreshToken

        @trigger 'authorized', data
        resolve(data)
        cb(null, data)

  refreshTokens: (cb = ->) ->
    new RSVP.Promise (resolve, reject) =>
      needle.post @tokenEndpoint,
        grant_type: 'refresh_token',
        client_id: @config.oauthKey,
        client_secret: @config.oauthSecret,
        refresh_token: @config.refreshToken
      , (error, resp, body) =>
        if error?
          reject(error)
          cb(error, null)
          return

        @config.accessToken = body.access_token
        @config.refreshToken = body.refresh_token
        data = accessToken: @config.accessToken, refreshToken: @config.refreshToken

        @trigger 'authorized', data
        resolve(data)
        cb(null, data)

RSVP.EventTarget.mixin(Authenticate::)