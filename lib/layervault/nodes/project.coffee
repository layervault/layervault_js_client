Node = require '../node'

module.exports = class Project extends Node
  get: (cb) -> @api.get(@path, {}, cb.call(@))
  create: (cb) -> @api.post(@path, {}, cb.call(@))
  delete: (cb) -> @api.delete(@path, {}, cb.call(@))
  move: (to, cb) -> @api.post("#{@path}/move", { to: to }, cb.call(@))
  color: (color, cb) -> @api.put(@path, { color: color }, cb.call(@))