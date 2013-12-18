needle  = require 'needle'
Md5Service = require './md5'

module.exports = class UploadService
  S3_ENDPOINT = 'https://omnivore-scratch.s3.amazonaws.com'

  constructor: (@file, options) ->
    {@localPath, @contentType} = options
    @api = @file.api
    @md5 = new Md5Service(@localPath)

  perform: (cb) ->
    @md5.calculate (md5) => 
      @getAwsCredentials md5, (err, resp) =>
        return cb(err, null) if err
        @sendFileToS3 resp, cb

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