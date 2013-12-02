request = require 'request'
qs = require 'querystring'

module.exports = class API
  constructor: (@config) ->

  get: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = {}
    headers["Authorization"] = "Bearer #{@config.accessToken}" unless options.auth is false

    options =
      url: @apiUrl(endpoint, options)
      headers: headers

    options.url += "?#{qs.stringify(data)}"
    
    request.get options, (error, response, body) ->
      return cb(null, JSON.parse(body)) if 200 <= response.statusCode < 300
      return cb(JSON.parse(body), null)

  post: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = {}
    headers["Authorization"] = "Bearer #{@config.accessToken}" unless options.auth is false

    options =
      url: @apiUrl(endpoint, options)
      headers: headers
      form: data

    request.post options, (error, response, body) ->
      return cb(null, JSON.parse(body)) if 200 <= response.statusCode < 300
      return cb(JSON.parse(body), null)

  apiUrl: (endpoint, options) ->
    path = @config.apiBase
    path += @config.apiPath unless options.excludeApiPath
    path += endpoint + ".json"

    return path