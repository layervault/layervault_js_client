crypto = require 'crypto'
fs = require 'fs'
needle = require 'needle'
url = require 'url'

Node = require '../node'

module.exports = class File extends Node
  S3_ENDPOINT = 'https://omnivore-scratch.s3.amazonaws.com'

  get: (cb) -> @api.get(@path, {}, cb.bind(@))
  create: (options, cb) ->
    {@localPath, @contentType} = options
    @callback = cb
    @calculateMd5 @getAwsCredentials

  calculateMd5: (cb) ->
    md5 = crypto.createHash 'md5'
    s = fs.ReadStream(@localPath)
    s.on 'data', (d) -> md5.update(d)
    s.on 'end', -> cb md5.digest('hex')

  getAwsCredentials: (md5) =>
    @api.put @path, md5: md5, @sendFileToS3, format: false

  sendFileToS3: (err, resp) =>
    options = resp
    options['Content-Type'] = @contentType
    options.file =
      content_type: @contentType
      file: @localPath

    needle.post S3_ENDPOINT, 
      options,
      { multipart: true },
      (err, resp, body) =>
        return @callback(err, null) if err

        location = resp.headers.location
        parsedUrl = url.parse(location, true)
        parsedUrl.query.access_token = @api.config.accessToken
        parsedUrl.query.file_size = fs.statSync(@localPath).size
        
        delete parsedUrl.search
        parsedUrl = url.format(parsedUrl)

        needle.post parsedUrl, {headers: {'Authorization': @api.config.accessToken}}, (err, resp, body) =>
          delete @localPath
          delete @contentType
          @callback(err, body)

  fileName: -> @nodeName.match(/\/([^\/])$/)[1]