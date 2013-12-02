request = require 'request'

module.exports = class API
  constructor: (@config) ->

  get: (endpoint) ->

  post: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = {}
    headers["Authorization"] = "Bearer #{@config.accessToken}" if options.auth

    options =
      url: @apiUrl(endpoint, options)
      headers: headers
      form: data

    request.post options, (error, response, body) =>
      return cb(null, JSON.parse(body)) if response.statusCode is 200
      return cb(JSON.parse(body), null)

  apiUrl: (endpoint, options) ->
    path = @config.apiBase
    path += @config.apiPath unless options.excludeApiPath
    path += endpoint + ".json"

    return path