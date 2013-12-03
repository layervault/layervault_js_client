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