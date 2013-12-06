Node = require '../node'
UploadService = require '../services/upload'

module.exports = class File extends Node
  get: (cb) -> @api.get(@path, {}, cb.bind(@))
  create: (options, cb) ->
    service = new UploadService(@, options)
    service.perform cb

  fileName: -> @nodeName.match(/\/([^\/])$/)[1]