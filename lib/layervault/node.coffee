module.exports = class Node
  constructor: (@api, parent, @nodeName) ->
    @nodeName = @nodeName.name if typeof @nodeName is "object"
    @path = parent.path + "/#{encodeURIComponent(@nodeName)}"
    @initialize()

  initialize: ->