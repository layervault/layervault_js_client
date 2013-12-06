Node = require '../node'
Project = require './project'

module.exports = class Organization extends Node
  relations:
    projects:
      klass: Project
      pathProperty: 'name'

  get: (cb) -> @api.get @path, {}, @buildRelations(cb)