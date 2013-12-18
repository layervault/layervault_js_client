Node = require '../node'
UploadService = require '../services/upload'
Md5Service = require '../services/md5'

Revision = require './revision'

module.exports = class File extends Node
  relations:
    revisions: Revision

  get: (cb) -> @api.get @nodePath, {}, @buildRelations(cb)

  create: (options, cb) ->
    service = new UploadService(@, options)
    service.perform cb.bind(@)

  delete: (opts, cb) ->
    if opts.md5?
      md5 = opts.md5
    else if opts.localPath?
      service = new Md5Service(opts.localPath)
      service.calculate (md5) => @delete {md5: md5}, cb
    else
      throw "Deleting a file requires the md5 of the latest revision"

    @api.delete @nodePath, {md5: md5}, cb.bind(@)

  move: (to, cb) -> @api.post("#{@nodePath}/move", { to: to }, cb.bind(@))
  rename: @move

  revisions: (cb) -> @api.get("#{@nodePath}/revisions", {}, @buildRelationsArray('revisions', @relations.revisions, cb))
  preview: (args...) ->
    [opts, cb] = @parsePreviewOptions(args)
    @api.get("#{@nodePath}/preview", opts, cb.bind(@))

  previews: (args...) ->
    [opts, cb] = @parsePreviewOptions(args)
    @api.get("#{@nodePath}/previews", opts, cb.bind(@))

  feedbackItems: (cb) -> @api.get "#{@nodePath}/feedback_items", {}, cb.bind(@)
  feedback: @feedbackItems