Node = require '../node'
File = require './file'
Folder = require './folder'

# Represents a single LayerVault Project. Projects are always tied to a top-level
# Folder in the LayerVault tree.
module.exports = class Project extends Node
  relations:
    files: File
    folders: Folder

  # Retrieves information about this project.
  #
  # @param [Function] cb The finished callback.
  get: (cb) -> @api.get @nodePath, {}, @buildRelations(cb)

  # Creates a project (and folder) at the root of the organization.
  #
  # @param [Function] cb The finished callback.
  create: (cb) -> @api.post @nodePath, {}, @buildRelations(cb)

  # Deletes this project (and folder).
  #
  # @param [Function] cb The finished callback.
  delete: (cb) -> @api.delete @nodePath, {}, cb.bind(@)
  
  # Moves/renames this project (and folder).
  #
  # @param [String] to The new name for the project.
  # @param [Function] cb The finished callback.
  move: (to, cb) -> @api.post "#{@nodePath}/move", { to: to }, @buildRelations(cb)

  # @see Project#move
  rename: (args...) -> @move.apply(@, args)

  # Changes the color of the folder. Possible values include: white, green, orange, and red.
  #
  # @param [String] color The new color.
  # @param [Function] cb The finished callback.
  changeColor: (color, cb) -> @api.put("#{@nodePath}/color", { color: color }, cb.bind(@))