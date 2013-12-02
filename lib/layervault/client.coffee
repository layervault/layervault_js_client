Authenticate = require './authenticate'
API = require './api'

Organization = require './organization'

module.exports = class Client
  constructor: (@config) ->
    @auth = new Authenticate(@config)
    @api = new API(@config)

  me: (cb) -> @api.get '/me', {}, cb
  organization: (name) -> new Organization(name, @api)