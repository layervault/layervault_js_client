Authenticate = require './authenticate'

module.exports = class Client
  constructor: (@config) ->
    @auth = new Authenticate(@config)