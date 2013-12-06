Node = require '../node'
Project = require './project'

module.exports = class Organization extends Node
  relations:
    projects: Project

  get: (cb) -> @api.get @nodePath, {}, @buildRelations(cb)