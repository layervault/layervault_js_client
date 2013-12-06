Node = require '../node'
File = require './file'
Folder = require './folder'

module.exports = class Project extends Node
  relations:
    files: File
    folders: Folder

  get: (cb) -> @api.get @nodePath, {}, @buildRelations(cb)
  create: (cb) -> @api.post(@nodePath, {}, cb.bind(@))
  delete: (cb) -> @api.delete(@nodePath, {}, cb.bind(@))
  
  move: (to, cb) -> @api.post("#{@nodePath}/move", { to: to }, cb.bind(@))
  rename: @move

  changeColor: (color, cb) -> @api.put("#{@nodePath}/color", { color: color }, cb.bind(@))