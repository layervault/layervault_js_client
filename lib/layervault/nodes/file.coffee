Node = require '../node'
UploadService = require '../services/upload'

Revision = require './revision'

module.exports = class File extends Node
  relations:
    revisions: 
      klass: Revision
      pathProperty: 'revision_number'

  get: (cb) -> @api.get @path, {}, @buildRelations(cb)

  create: (options, cb) ->
    service = new UploadService(@, options)
    service.perform cb.bind(@)

  delete: (cb) -> @api.delete(@path, {}, cb.bind(@))
  move: (to, cb) -> @api.post("#{@path}/move", { to: to }, cb.bind(@))
  rename: @move

  revisions: (cb) -> @api.get("#{@path}/revisions", {}, @buildRelationsArray('revisions', @relations.revisions, cb))