module.exports = class Configuration
  constructor: (cb = null) ->
    @oauthKey = null
    @oauthSecret = null
    @accessToken = null
    @apiBase = "https://api.layervault.com/"
    @apiPath = "/api/v1"

    @setup(cb) if cb?

  setup: (cb) -> cb.call(@)