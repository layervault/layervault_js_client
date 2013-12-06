Node = require '../node'
UploadService = require '../services/upload'

module.exports = class File extends Node
  get: (cb) -> @api.get(@path, {}, cb.bind(@))
  create: (options, cb) ->
    service = new UploadService(@, options)
    service.perform cb.bind(@)

  delete: (cb) -> @api.delete(@path, {}, cb.bind(@))
  move: (to, cb) -> @api.post("#{@path}/move", { to: to }, cb.bind(@))
  rename: @move

  revisions: (cb) -> @api.get("#{@path}/revisions", {}, cb.bind(@))

  fileName: -> @nodeName.match(/\/([^\/])$/)[1]