Node = require '../node'

module.exports = class Revision extends Node
  get: (cb) -> @api.get @nodePath, {}, cb.bind(@)
  preview: (args...) ->
    [opts, cb] = @parsePreviewOptions(args)
    @api.get "#{@nodePath}/preview", opts, cb.bind(@)

  previews: (args...) ->
    [opts, cb] = @parsePreviewOptions(args)
    @api.get "#{@nodePath}/previews", opts, cb.bind(@)

  meta: (cb) -> @api.get "#{@nodePath}/meta", {}, cb.bind(@)
  feedbackItems: (cb) -> @api.get "#{@nodePath}/feedback_items", {}, cb.bind(@)
  feedback: @feedbackItems