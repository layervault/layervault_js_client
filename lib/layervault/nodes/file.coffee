Node = require '../node'
UploadService = require '../services/upload'

Revision = require './revision'

module.exports = class File extends Node
  relations:
    revisions: Revision

  get: (cb) -> @api.get @nodePath, {}, @buildRelations(cb)

  create: (options, cb) ->
    service = new UploadService(@, options)
    service.perform cb.bind(@)

  delete: (cb) -> @api.delete(@nodePath, {}, cb.bind(@))
  move: (to, cb) -> @api.post("#{@nodePath}/move", { to: to }, cb.bind(@))
  rename: @move

  revisions: (cb) -> @api.get("#{@nodePath}/revisions", {}, @buildRelationsArray('revisions', @relations.revisions, cb))