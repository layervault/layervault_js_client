crypto  = require 'crypto'
fs      = require 'fs'

module.exports = class Md5Service
  constructor: (@file) ->

  calculate: (cb) ->
    md5 = crypto.createHash 'md5'
    s = fs.ReadStream(@file)
    s.on 'data', (d) -> md5.update(d)
    s.on 'end', -> cb md5.digest('hex')