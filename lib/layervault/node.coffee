module.exports = class Node
  constructor: (@api, parent, nodePath) ->
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
    @nodeName = nodePath.match(/([^\/]+)$/)[1]

    @initialize()

  initialize: ->

  project: (name) -> new Project(@api, @, name)
  folder: (path...) ->  new Folder(@api, @, path)
  file: (path...) -> new File(@api, @, path)

Project = require './nodes/project'
Folder = require './nodes/folder'
File = require './nodes/file'