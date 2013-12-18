crypto  = require 'crypto'
fs      = require 'fs'
needle  = require 'needle'

module.exports = class UploadService
  S3_ENDPOINT = 'https://omnivore-scratch.s3.amazonaws.com'

  constructor: (@file, options) ->
    {@localPath, @contentType} = options
    @api = @file.api

  perform: (cb) ->
    @calculateMd5 (md5) => 
      @getAwsCredentials md5, (err, resp) =>
        return cb(err, null) if err
        @sendFileToS3 resp, cb

  calculateMd5: (cb) ->
    md5 = crypto.createHash 'md5'
    s = fs.ReadStream(@localPath)
    s.on 'data', (d) -> md5.update(d)
    s.on 'end', -> cb md5.digest('hex')

  getAwsCredentials: (md5, cb) => @api.put @file.nodePath, md5: md5, cb

  sendFileToS3: (resp, cb) =>
    options = resp
    options['Content-Type'] = @contentType
    options.file =
      content_type: @contentType
      file: @localPath

    needle.post S3_ENDPOINT, 
      options,
      { multipart: true },
      (err, resp, body) =>
        return cb(err, null) if err

        location = resp.headers.location
        location += "&access_token=#{@api.config.accessToken}"

        needle.post location, {}, (err, resp, body) => cb(err, body)