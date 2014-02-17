Authenticate = require './authenticate'
API = require './api'

Node = require './node'
Organization = require './nodes/organization'

# The API client base. Holds references to our authentication and configuration.
# It lets you choose an organization for the API request, and the other classes
# handle things from there.
module.exports = class Client
  # Constructs a new client object.
  #
  # @param [Configuration] config The configuration to use for this client
  constructor: (@config) ->
    @auth = new Authenticate(@config)
    @api = new API(@, @config)
    @nodePath = ''

  # Fetches information about the logged in user
  #
  # @param [Function] cb The finished callback
  me: (cb = ->) -> @api.get '/me', {}, cb.bind(@)

  # Chooses an {Organization} to work with based on the name,
  # and instantiates it for you.
  #
  # @param [String] name The name of the {Organization}. Must be in permalink form.
  organization: (name) -> new Organization(@api, @, name)