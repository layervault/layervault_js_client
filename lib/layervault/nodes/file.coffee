Node = require '../node'

module.exports = class File extends Node
  get: (cb) -> @api.get(@path, {}, cb.bind(@))