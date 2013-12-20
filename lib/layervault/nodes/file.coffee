Node = require '../node'
UploadService = require '../services/upload'
Md5Service = require '../services/md5'

Revision = require './revision'

# Represents a single LayerVault File
module.exports = class File extends Node
  relations:
    revisions: Revision

  # Retrieves information about the file at this path.
  #
  # @param [Function] cb The finished callback.
  get: (cb) -> @api.get @nodePath, {}, @buildRelations(cb)

  # Creates a file or a new revision at this path. Must be given
  # a path to a file on disk and a mime-type for the file.
  #
  # @param [Object] options Configuration options for the file.
  # @option options [String] localPath Path to the file on disk.
  # @option options [String] contentType The mime-type of the file.
  # @param [Function] cb The finished callback.
  create: (options, cb) ->
    service = new UploadService(@, options)
    service.perform @buildRelations(cb)

  # Deletes the file at this path. Requires the MD5 of the latest version so
  # that the server can validate it's deleting the right version.
  #
  # @param [Object] opts Configuration options. Can supply MD5 or path to the file.
  # @option options [String] md5 The md5 of this file.
  # @option options [String] localPath The path to this file on disk. The MD5 will be calculated.
  # @param [Function] cb The finished callback.
  delete: (opts, cb) ->
    if opts.md5?
      md5 = opts.md5
    else if opts.localPath?
      service = new Md5Service(opts.localPath)
      service.calculate (md5) => @delete { md5: md5 }, cb
    else
      throw "Deleting a file requires the md5 of the latest revision"

    @api.delete @nodePath, { md5: md5 }, cb.bind(@)

  # Moves this file to a new location in LayerVault. Must give the new folder path, but can optionally give
  # a new file name as well.
  #
  # @param [Object] opts The configuration options
  # @option opts [String] to (Required) The path of the folder where the file should reside. Relative to the organization root.
  # @option opts [String] new_file_name (Optional) The new file name for this file.
  # @param [Function] cb The finished callback.
  move: (opts, cb) -> @api.post("#{@nodePath}/move", opts, cb.bind(@))

  # @see File#move
  rename: @move

  # Retrieves all revisions for this file.
  #
  # @param [Function] cb The finished callback.
  revisions: (cb) -> @api.get("#{@nodePath}/revisions", {}, @buildRelationsArray('revisions', @relations.revisions, cb))

  # Retrieves the latest preview for this file.
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
    @api.get("#{@nodePath}/preview", opts, cb.bind(@))

  # Retrieves all of the previews for the latest revision of this file.
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
    @api.get("#{@nodePath}/previews", opts, cb.bind(@))

  # Retrieves all feedback items left on this File.
  #
  # @param [Function] cb The finished callback.
  feedbackItems: (cb) -> @api.get "#{@nodePath}/feedback_items", {}, cb.bind(@)

  # @see File#feedbackItems
  feedback: @feedbackItems