# Stores the configuration info for the {Client}
module.exports = class Configuration
  # Constructs a new Configuration object
  #
  # @param [Function] cb
  #   Allows you to configure the settings immediately without calling setup.
  constructor: (cb = null) ->
    @oauthKey = null
    @oauthSecret = null
    @accessToken = null
    @refreshToken = null
    @apiBase = "https://api.layervault.com"
    @apiPath = "/api/v1"

    @setup(cb) if cb?

  # Executes a callback in the context of this Configuration object.
  # Mostly a stylistic way to set the configuration options.
  #
  # @param [Function] cb Executes the callback under the context of this object
  setup: (cb) -> cb.call(@)