Node = require '../node'
Project = require './project'
Folder = require './folder'

module.exports = class Organization extends Node
  get: (cb) -> @api.get(@path, {}, cb.bind(@))
  project: (name) -> new Project(@api, @, name)
  folder: (path...) ->  new Folder(@api, @, path)