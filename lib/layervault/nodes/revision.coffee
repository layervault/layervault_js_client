Node = require '../node'

# Represents a single LayerVault Revision.
module.exports = class Revision extends Node
  # Retrieves information about this revision.
  #
  # @param [Function] cb The finished callback.
  get: (cb = ->) -> @api.get @nodePath, {}, cb.bind(@)

  # Retrieves the first preview for this revision.
  #
  # @overload preview(cb)
  #   Fetches the preview in its original state.
  #   @param [Function] cb The finished callback.
  #
  # @overload preview(opts, cb)
  #   Fetches the preview and sends transformations to Imgix.
  #   @param [Object] opts Hash of options to pass to Imgix for formatting the preview.
  #   @param [Function] cb The finished callback.
  preview: (args...) ->
    [opts, cb] = @parsePreviewOptions(args)
    @api.get "#{@nodePath}/preview", opts, cb.bind(@)

  # Retrieves all of the previews for this revision.
  #
  # @overload previews(cb)
  #   Fetches the previews in their original state.
  #   @param [Function] cb The finished callback.
  #
  # @overload previews(opts, cb)
  #   Fetches the previews and sends transformations to Imgix.
  #   @param [Object] opts Hash of options to pass to Imgix for formatting the preview.
  #   @param [Function] cb The finished callback.
  previews: (args...) ->
    [opts, cb] = @parsePreviewOptions(args)
    @api.get "#{@nodePath}/previews", opts, cb.bind(@)

  # Retrieves metadata parsed for this revision.
  #
  # @param [Function] cb The finished callback.
  meta: (cb = ->) -> @api.get "#{@nodePath}/meta", {}, cb.bind(@)

  # Retrieves all feedback left on this revision.
  #
  # @param [Function] cb The finished callback.
  feedbackItems: (cb = ->) -> @api.get "#{@nodePath}/feedback_items", {}, cb.bind(@)

  # @see Revision#feedbackItems
  feedback: (args...) -> @feedbackItems.apply(@, args)