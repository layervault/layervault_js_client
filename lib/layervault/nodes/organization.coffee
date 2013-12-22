Node = require '../node'
Project = require './project'

# A single LayerVault Organization. The starting point for all
# API queries.
module.exports = class Organization extends Node
  relations:
    projects: Project

  # Retrieves information about this organization.
  #
  # @param [Function] cb The finished callback.
  get: (cb = ->) -> @api.get @nodePath, {}, @buildRelations(cb)