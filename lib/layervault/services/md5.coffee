RSVP    = require 'rsvp'
crypto  = require 'crypto'
fs      = require 'fs'

# Simple service that, given a path to a file, calculates
# its MD5.
module.exports = class Md5Service
  # Constructs a new Md5Service.
  #
  # @param [String] file The path to the file.
  constructor: (@file) ->

  # Runs the MD5 calculation by reading the file with a ReadStream,
  # and passes the chunks to our MD5 function. This is done
  # asynchronously. The resulting MD5 is given in hex form.
  #
  # @param [Function] cb The finished callback.
  calculate: (cb = ->) ->
    new RSVP.Promise (resolve, reject) =>
      md5 = crypto.createHash 'md5'
      s = fs.ReadStream(@file)
      s.on 'data', (d) -> md5.update(d)
      s.on 'end', ->
        digest = md5.digest('hex')
        cb(digest)
        resolve(digest)