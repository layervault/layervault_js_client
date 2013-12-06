Node = require '../node'

module.exports = class Folder extends Node
  get: (cb) -> @api.get(@path, {}, cb.bind(@))
  create: (cb) -> @api.post(@path, {}, cb.bind(@))
  delete: (cb) -> @api.delete(@path, {}, cb.bind(@))
  move: (to, cb) -> @api.post("#{@path}/move", { to: to }, cb.bind(@))
  color: (color, cb) -> @api.put("#{@path}/color", { color: color }, cb.bind(@))