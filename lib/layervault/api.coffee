needle = require 'needle'
qs = require 'querystring'
util = require 'util'

# API request helper class. Relies on needle for issuing HTTP requests.
# Formats callback arguments such that they are always called with (error, response).
# If there is an error, then the error parameter will have data. Otherwise, it will be
# null.
module.exports = class API
  # Construct a new API class
  #
  # @param [Configuration] config The client configuration
  constructor: (@config) ->

  # Issues a GET request to the API
  #
  # @param [String] endpoint The API endpoint
  # @param [Object] data GET data that will be compiled into the querystring
  # @param [Function] cb Callback function when request finishes
  # @param [Object] options Options to configure this request
  # @option options [Boolean] excludeApiPath Should we include the API path on the base domain?
  # @option options [Boolean] auth Should we add the Authorization header?
  get: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = {}
    headers["Authorization"] = "Bearer #{@config.accessToken}" unless options.auth is false

    url = @apiUrl(endpoint, options)
    url += "?#{qs.stringify(data)}" unless Object.keys(data).length is 0

    needle.get url, {
      headers: headers
    }, (error, response, body) ->
      # console.log util.inspect body, depth: null
      return cb(null, body) if 200 <= response.statusCode < 300
      return cb(body, null)

  # Issues a POST request to the API
  #
  # @param [String] endpoint The API endpoint
  # @param [Object] data Additional data that will be added to the request
  # @param [Function] cb Callback function when request finishes
  # @param [Object] options Options to configure this request
  # @option options [Boolean] excludeApiPath Should we include the API path on the base domain?
  # @option options [Boolean] auth Should we add the Authorization header?
  post: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = {}
    headers["Authorization"] = "Bearer #{@config.accessToken}" unless options.auth is false

    needle.post @apiUrl(endpoint, options), data, {
      headers: headers
    }, (error, response, body) ->
      return cb(null, body) if 200 <= response.statusCode < 300
      return cb(body, null)

  # Issues a DELETE request to the API. Authorization is always enabled.
  #
  # @param [String] endpoint The API endpoint
  # @param [Object] data Additional data that will be added to the request
  # @param [Function] cb Callback function when request finishes
  # @param [Object] options Options to configure this request
  # @option options [Boolean] excludeApiPath Should we include the API path on the base domain?
  delete: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = { 'Authorization': "Bearer #{@config.accessToken}" }

    needle.delete @apiUrl(endpoint, options), data, {
      headers: headers
    }, (error, response, body) ->
      return cb(null, body) if 200 <= response.statusCode < 300
      return cb(body, null)

  # Issues a PUT request to the API. Authorization is always enabled.
  #
  # @param [String] endpoint The API endpoint
  # @param [Object] data Additional data that will be added to the request
  # @param [Function] cb Callback function when request finishes
  # @param [Object] options Options to configure this request
  # @option options [Boolean] excludeApiPath Should we include the API path on the base domain?
  put: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = { 'Authorization': "Bearer #{@config.accessToken}" }

    needle.put @apiUrl(endpoint, options), data, {
      headers: headers
    }, (error, response, body) ->
      return cb(null, body) if 200 <= response.statusCode < 300
      return cb(body, null)

  # Builds an API url
  #
  # @param [String] endpoint The API endpoint
  # @param [Object] options Options to configure this request
  # @option options [Boolean] excludeApiPath Should we include the API path on the base domain?
  apiUrl: (endpoint, options) ->
    path = @config.apiBase
    path += @config.apiPath unless options.excludeApiPath
    path += endpoint

    return path