Authenticate = require './authenticate'
API = require './api'

Node = require './node'
Organization = require './nodes/organization'

module.exports = class Client
  constructor: (@config) ->
    @auth = new Authenticate(@config)
    @api = new API(@config)
    @path = ''

  me: (cb) -> @api.get '/me', {}, cb
  organization: (name) -> new Organization(@api, @, name)