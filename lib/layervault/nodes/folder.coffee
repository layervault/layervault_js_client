Node = require '../node'

# Represents a single Folder in LayerVault
module.exports = class Folder extends Node
  # Retrieves information about this folder.
  #
  # @param [Function] cb The finished callback.
  get: (cb) -> @api.get(@nodePath, {}, cb.bind(@))

  # Creates a folder at this path.
  #
  # @param [Function] cb The finished callback.
  create: (cb) -> @api.post(@nodePath, {}, cb.bind(@))

  # Deletes the folder at this path.
  #
  # @param [Function] cb The finished callback.
  delete: (cb) -> @api.delete(@nodePath, {}, cb.bind(@))

  # Moves this folder to a new location. The new location must be relative to the
  # organization root.
  #
  # @param [String] to The new path for the folder relative to the organization root.
  # @param [Function] cb The finished callback.
  move: (to, cb) -> @api.post("#{@nodePath}/move", { to: to }, cb.bind(@))

  # @see Folder#move
  rename: @move

  # Changes the color of the folder. At this time, the color is only reflected
  # on the site for project folders. Possible values include: white, green,
  # orange, and red.
  #
  # @param [String] color The color to change this folder to.
  # @param [Function] cb The finished callback.
  changeColor: (color, cb) -> @api.put("#{@nodePath}/color", { color: color }, cb.bind(@))