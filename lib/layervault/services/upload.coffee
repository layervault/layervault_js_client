RSVP = require 'rsvp'
needle  = require 'needle'
Md5Service = require './md5'

# Service that handles the file upload process for LayerVault.
# Uploading a file is a multi-step process.
#
# 1. We use our {Md5Service} to calculate the MD5 of the given file.
# 2. We then send a request to LayerVault notifying it of our intentions
#    to upload a file, giving it the MD5 and the desired location.
#    We get back the S3 parameters for our next request.
# 3. The file is sent to the S3 scratch bucket and we get a callback URL
#    for our next request.
# 4. We take the callback URL, add our OAuth access token, and make the final
#    request to LayerVault to let it know the file is ready for processing.
module.exports = class UploadService
  S3_ENDPOINT = 'https://omnivore-scratch.s3.amazonaws.com'

  # Constructs a new UploadService object.
  #
  # @param [String] file The File object we want to create.
  # @param [Object] options The configuration options for the file.
  # @option options [String] localPath The path to the file on the filesystem.
  # @option options [String] contentType The mime-type of the file.
  constructor: (@file, options) ->
    {@localPath, @contentType} = options
    @api = @file.api
    @md5 = new Md5Service(@localPath)

  # Starts the upload process.
  #
  # @param [Function] cb The finished callback.
  perform: (cb = ->) ->
    new RSVP.Promise (resolve, reject) =>
      @md5.calculate (md5) => 
        @getAwsCredentials md5, (err, resp) =>
          if err?
            reject(err)
            cb(err, null)
            return

          @sendFileToS3 resp, (err, data) =>
            if err?
              reject(err)
              cb(err, null)
            else
              resolve(data)
              cb(null, data)




  # Fetches the S3 credentials and information from LayerVault.
  getAwsCredentials: (md5, cb) -> @api.put @file.nodePath, md5: md5, cb

  # Sends the file to the S3 bucket and notifies LayerVault that the upload
  # is complete.
  sendFileToS3: (resp, cb) ->
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
