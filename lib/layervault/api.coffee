RSVP    = require 'rsvp'
needle  = require 'needle'
qs      = require 'querystring'

# API request helper class. Relies on needle for issuing HTTP requests.
# Formats callback arguments such that they are always called with (error, response).
# If there is an error, then the error parameter will have data. Otherwise, it will be
# null.
module.exports = class API
  # Construct a new API class
  #
  # @param [Client] client The initialized client
  # @param [Configuration] config The configuration options
  constructor: (@client, @config) ->

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

    new RSVP.Promise (resolve, reject) =>
      needle.get url, {
        headers: headers
      }, (error, response, body) =>
        if 200 <= response.statusCode < 300
          resolve(body)
          cb(null, body)
        else
          # Access token is expired. We must refresh it and attempt the request again.
          if body.error is 'invalid_request'
            @client.auth.refreshTokens()
              .then((tokens) => @get(endpoint, data, cb, options))
              .fail((error) => reject(error))

            return

          reject(body)
          cb(body, null)

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

    url = @apiUrl(endpoint, options)

    new RSVP.Promise (resolve, reject) =>
      needle.post url, data, {
        headers: headers
      }, (error, response, body) =>
        if 200 <= response.statusCode < 300
          resolve(body)
          cb(null, body)
        else
          # Access token is expired. We must refresh it and attempt the request again.
          if body.error is 'invalid_request'
            @client.auth.refreshTokens()
              .then((tokens) => @post(endpoint, data, cb, options))
              .fail((error) => reject(error))

            return

          reject(body)
          cb(body, null)

  # Issues a DELETE request to the API. Authorization is always enabled.
  #
  # @param [String] endpoint The API endpoint
  # @param [Object] data Additional data that will be added to the request
  # @param [Function] cb Callback function when request finishes
  # @param [Object] options Options to configure this request
  # @option options [Boolean] excludeApiPath Should we include the API path on the base domain?
  delete: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = { 'Authorization': "Bearer #{@config.accessToken}" }

    url = @apiUrl(endpoint, options)

    new RSVP.Promise (resolve, reject) =>
      needle.delete url, data, {
        headers: headers
      }, (error, response, body) =>
        if 200 <= response.statusCode < 300
          resolve(body)
          cb(null, body)
        else
          # Access token is expired. We must refresh it and attempt the request again.
          if body.error is 'invalid_request'
            @client.auth.refreshTokens()
              .then((tokens) => @delete(endpoint, data, cb, options))
              .fail((error) => reject(error))

            return

          reject(body)
          cb(body, null)

  # Issues a PUT request to the API. Authorization is always enabled.
  #
  # @param [String] endpoint The API endpoint
  # @param [Object] data Additional data that will be added to the request
  # @param [Function] cb Callback function when request finishes
  # @param [Object] options Options to configure this request
  # @option options [Boolean] excludeApiPath Should we include the API path on the base domain?
  put: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = { 'Authorization': "Bearer #{@config.accessToken}" }

    url = @apiUrl(endpoint, options)

    new RSVP.Promise (resolve, reject) =>
      needle.put url, data, {
        headers: headers
      }, (error, response, body) =>
        if 200 <= response.statusCode < 300
          resolve(body)
          cb(null, body)
        else
          # Access token is expired. We must refresh it and attempt the request again.
          if body.error is 'invalid_request'
            @client.auth.refreshTokens()
              .then((tokens) => @put(endpoint, data, cb, options))
              .fail((error) => reject(error))

            return

          reject(body)
          cb(body, null)

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