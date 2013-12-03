module.exports = class Node
  constructor: (@api, parent, nodeName) ->
    if Array.isArray(nodeName)
      components = []
      for node in nodeName
        components.push if typeof node is "object" then encodeURIComponent(node.name) else encodeURIComponent(node)

      @nodeName = components.join('/')
    else if typeof nodeName is "object"
      @nodeName = encodeURIComponent(nodeName.name)
    else
      @nodeName = encodeURIComponent(nodeName)

    @path = parent.path + "/#{@nodeName}"
    @initialize()

  initialize: ->

  project: (name) -> new Project(@api, @, name)
  folder: (path...) ->  new Folder(@api, @, path)
  file: (path...) -> new File(@api, @, path)

Project = require './nodes/project'
Folder = require './nodes/folder'
File = require './nodes/file'