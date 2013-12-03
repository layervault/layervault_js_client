Node = require '../node'
Project = require './project'

module.exports = class Organization extends Node
  get: (cb) -> @api.get(@path, {}, cb.call(@))
  project: (name) -> new Project(@api, @, name)