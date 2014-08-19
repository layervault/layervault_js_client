# The base class for all LayerVault node types.
# This incldues: {Organization}, {Folder}, {Project}, {File}, and {Revision}.
module.exports = class Node
  # @property [Object] The associations for this Node
  relations: {}

  # Constructs a new Node object. This should never be instantiated directly,
  # but instead through a Node subclass.
  #
  # @overload constructor(@api, nodePath)
  #   @param [API] api Reference to the configured {API} helper
  #   @param [String] nodePath The full path to this node
  #
  # @overload constructor(@api, parent, nodePath)
  #   @param [API] api Reference to the configured {API} helper
  #   @param [Node] parent The parent node to this node
  #   @param [String] nodePath The path of this node relative to the parent node
  constructor: (@api, args...) ->
    if args.length is 1
      @nodePath = args[0]
    else
      [parent, nodePath] = args
      if Array.isArray(nodePath)
        components = []
        for node in nodePath
          name = if typeof node is "object" then node.nodeName else node
          components.push @formatNodePath(name)

        nodePath = components.join('/')
      else if typeof nodePath is "object"
        nodePath = @formatNodePath nodePath.nodeName
      else
        nodePath = @formatNodePath nodePath

      @nodePath = parent.nodePath + "/#{nodePath}"

    @nodeName = @nodePath.match(/([^\/]+)$/)[1]
    @data = {}

  formatNodePath: (path) -> path.toString().split('/').map((p) -> encodeURIComponent(p)).join('/')

  # Assigns the data for this node and sets up getters/setters with
  # the proper options so that they are enumerable.
  #
  # @param [Object] data The properties and values to assign to this node.
  withData: (data) ->
    for own key, val of data then do (key, val) =>
      @data[key] = val
      Object.defineProperty @, key,
        configurable: true
        enumerable: true
        get: -> @data[key]
        set: (val) -> @data[key] = val

    return @

  # Provides a callback function for API requests that builds relations with
  # the API response and assigns them to this node. The relations must be configured
  # with the @relations property.
  #
  # @param [Function] cb The user provided callback to call once relations are built.
  buildRelations: (cb) ->
    api = @api

    (err, resp) =>
      return cb.call(@, err, resp) if err

      for own relation, klass of @relations
        continue unless resp[relation]?

        if Array.isArray(resp[relation])
          resp[relation] = resp[relation].map (r) -> 
            (new klass(api, @, r.name)).withData(r)
          , @
        else
          resp[relation] = (new klass(api, @, resp[relation][opts.pathProperty])).withData(resp[relation])

      @withData(resp)
      cb.call(@, err, resp)

  # Similar to {Node#buildRelations}, but builds an array of relations instead.
  #
  # @param [String] prop The property to check for the relation array.
  # @param [Object] klass The class to use when building the relation.
  # @param [Function] cb The user provided callback to call once relations are built.
  buildRelationsArray: (prop, klass, cb) ->
    api = @api

    (err, resp) =>
      return cb.call(@, err, resp) if err

      resp = resp.map (r) ->
        (new klass(api, @, r.name)).withData(r)
      , @

      relations = {}; relations[prop] = resp
      @withData relations
      
      cb.call(@, err, resp)

  parsePreviewOptions: (args) ->
    if args.length is 0
      parsedArgs = [{}, (->)]
    else if typeof args[0] is 'function'
      parsedArgs = [{}, args[0]]
    else
      parsedArgs = args

    parsedArgs[1] = (->) unless parsedArgs[1]
    return parsedArgs

  # Creates a new Project object based on the given name, and sets this
  # node as the parent node.
  #
  # @param [String] name The project name
  project: (name) -> new Project(@api, @, name)

  # Creates a new Folder object based on the given path, and sets this
  # node as the parent node.
  #
  # @param [String] path The path of the folder node relative to this node.
  folder: (path...) ->  new Folder(@api, @, path)

  # Creates a new File object based on the given path, and sets this
  # node as the parent node.
  #
  # @param [String] path The path of the file node relative to this node.
  file: (path...) -> new File(@api, @, path)

  # Creates a new Revision object based on the given path, and sets this
  # node as the parent node.
  #
  # @param [String] path The path of the revision node relative to this node.
  revision: (path...) -> new Revision(@api, @, path)

Project = require './nodes/project'
Folder = require './nodes/folder'
File = require './nodes/file'
Revision = require './nodes/revision'
