Node = require '../node'

module.exports = class Project extends Node
  get: (cb) -> @api.get(@path, {}, cb.bind(@))
  create: (cb) -> @api.post(@path, {}, cb.bind(@))
  delete: (cb) -> @api.delete(@path, {}, cb.bind(@))
  
  move: (to, cb) -> @api.post("#{@path}/move", { to: to }, cb.bind(@))
  rename: @move

  changeColor: (color, cb) -> @api.put("#{@path}/color", { color: color }, cb.bind(@))