module.exports = class Node
  constructor: (@api, args...) ->
    if args.length is 1
      @path = args[0]
    else
      [parent, nodePath] = args
      if Array.isArray(nodePath)
        components = []
        for node in nodePath
          components.push if typeof node is "object" then encodeURIComponent(node.name) else encodeURIComponent(node)

        nodePath = components.join('/')
      else if typeof nodePath is "object"
        nodePath = encodeURIComponent(nodePath.name)
      else
        nodePath = encodeURIComponent(nodePath)

      @path = parent.path + "/#{nodePath}"

    @nodeName = @path.match(/([^\/]+)$/)[1]
    @data = {}

    @initialize()

  initialize: ->

  withData: (data) ->
    for own key, val of data then do (key, val) =>
      @data[key] = val
      Object.defineProperty @, key,
        configurable: true
        enumerable: true
        get: -> @data[key]
        set: (val) -> @data[key] = val

    return @

  buildRelations: (cb) ->
    api = @api

    (err, resp) =>
      return cb.call(@, err, resp) if err

      for own relation, klass of @relations
        continue unless resp[relation]?

        if Array.isArray(resp[relation])
          resp[relation] = resp[relation].map (r) -> (new klass(api, r.full_url)).withData(r)
        else
          resp[relation] = (new klass(api, resp[relation].full_url)).withData(resp[relation])

      @withData(resp)
      cb.call(@, err, resp)

  project: (name) -> new Project(@api, @, name)
  folder: (path...) ->  new Folder(@api, @, path)
  file: (path...) -> new File(@api, @, path)

Project = require './nodes/project'
Folder = require './nodes/folder'
File = require './nodes/file'