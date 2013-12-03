needle = require 'needle'
qs = require 'querystring'

module.exports = class API
  constructor: (@config) ->

  get: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = {}
    headers["Authorization"] = "Bearer #{@config.accessToken}" unless options.auth is false

    url = @apiUrl(endpoint, options) + "?#{qs.stringify(data)}"

    needle.get url, {
      headers: headers
    }, (error, response, body) ->
      return cb(null, body) if 200 <= response.statusCode < 300
      return cb(body, null)

  post: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = {}
    headers["Authorization"] = "Bearer #{@config.accessToken}" unless options.auth is false

    needle.post @apiUrl(endpoint, options), data, {
      headers: headers
    }, (error, response, body) ->
      return cb(null, body) if 200 <= response.statusCode < 300
      return cb(body, null)

  delete: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = { 'Authorization': "Bearer #{@config.accessToken}" }

    needle.delete @apiUrl(endpoint, options), data, {
      headers: headers
    }, (error, response, body) ->
      return cb(null, body) if 200 <= response.statusCode < 300
      return cb(body, null)

  put: (endpoint, data = {}, cb = (->), options = {}) ->
    headers = { 'Authorization': "Bearer #{@config.accessToken}" }

    needle.put @apiUrl(endpoint, options), data, {
      headers: headers
    }, (error, response, body) ->
      return cb(null, body) if 200 <= response.statusCode < 300
      return cb(body, null)

  apiUrl: (endpoint, options) ->
    path = @config.apiBase
    path += @config.apiPath unless options.excludeApiPath
    path += endpoint

    return path if options.format is false
    path += if typeof format is "string" then ".#{format}" else ".json"

    return path