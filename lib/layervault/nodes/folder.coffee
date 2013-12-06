Node = require '../node'

module.exports = class Folder extends Node
  get: (cb) -> @api.get(@nodePath, {}, cb.bind(@))
  create: (cb) -> @api.post(@nodePath, {}, cb.bind(@))
  delete: (cb) -> @api.delete(@nodePath, {}, cb.bind(@))
  move: (to, cb) -> @api.post("#{@nodePath}/move", { to: to }, cb.bind(@))
  rename: @move

  changeColor: (color, cb) -> @api.put("#{@nodePath}/color", { color: color }, cb.bind(@))