expect  = require 'expect.js'
nock    = require 'nock'

LayerVault = require '../../lib/layervault'

describe 'File', ->
  before ->
    @config = new LayerVault.Configuration ->
      @accessToken = 'foobar'

    @client = new LayerVault.Client(@config)
    @organization = @client.organization('ryan-lefevre')

  beforeEach -> @file = @organization.file('Test Project', 'test.psd')

  describe 'get', ->
    beforeEach ->
      nock(@config.apiBase)
        .get("#{@config.apiPath}#{@file.nodePath}")
        .reply(200, require('../fixtures/file/get'))

    it 'does not error', (done) ->
      @file.get (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns a response object', (done) ->
      @file.get (err, resp) ->
        expect(resp).to.be.an('object')
        expect(resp.name).to.be('test.psd')
        done()

    it 'applies the data to the file object', (done) ->
      @file.get (err, resp) ->
        expect(@name).to.be('test.psd')
        done()

    it 'correctly initializes relations', (done) ->
      @file.get (err, resp) ->
        expect(@revisions.length).to.be(2)
        expect(@revisions[0].name).to.be('1')
        expect(@revisions[0].nodePath).to.be('/ryan-lefevre/Test%20Project/test.psd/1')
        expect(@revisions[0].get).to.be.a('function')
        done()

  describe 'create', ->
    beforeEach ->
      # Get S3 credentials
      nock(@config.apiBase)
        .put("#{@config.apiPath}#{@file.nodePath}")
        .reply(200, {})

      # POST to S3
      callbackUrl = @config.apiBase + @config.apiPath + @file.nodePath + "?code=abc"
      nock('https://omnivore-scratch.s3.amazonaws.com')
        .post('/')
        .reply(200, {}, {
          Location: callbackUrl
        })

      # Notify LayerVault file is ready
      nock(@config.apiBase)
        .post("#{@config.apiPath}#{@file.nodePath}?code=abc&access_token=#{@config.accessToken}")
        .reply(200, require('../fixtures/file/create'))

    it 'does not error', (done) ->
      @file.create {
        localPath: './test/fixtures/file/file.txt'
        contentType: 'application/json'
      }, (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns a file response object', (done) ->
      @file.create {
        localPath: './test/fixtures/file/file.txt'
        contentType: 'application/json'
      }, (err, resp) ->
        expect(resp).to.be.an('object')
        expect(resp.name).to.be('test.psd')
        done()

    it 'applies the data to the file object', (done) ->
      @file.create {
        localPath: './test/fixtures/file/file.txt'
        contentType: 'application/json'
      }, (err, resp) ->
        expect(@name).to.be('test.psd')
        done()

    it 'correctly builds relations', (done) ->
      @file.create {
        localPath: './test/fixtures/file/file.txt'
        contentType: 'application/json'
      }, (err, resp) ->
        expect(@revisions.length).to.be(1)
        expect(@revisions[0].name).to.be('1')
        expect(@revisions[0].nodePath).to.be('/ryan-lefevre/Test%20Project/test.psd/1')
        expect(@revisions[0].get).to.be.a('function')
        done()

  describe 'delete', ->
    before -> @fileMd5 = '0507dee9c033cd8d901950cdd1a23676'
    beforeEach ->
      nock(@config.apiBase)
        .delete("#{@config.apiPath}#{@file.nodePath}", {
          md5: @fileMd5
        })
        .reply(200, require('../fixtures/file/delete'))

    it 'can be performed with a pre-calculated MD5', (done) ->
      @file.delete md5: @fileMd5, (err, resp) ->
        expect(err).to.be(null)
        expect(resp.error).to.be('success')
        done()

    it 'can be performed with a local file path', (done) ->
      @file.delete localPath: './test/fixtures/file/file.txt', (err, resp) ->
        expect(err).to.be(null)
        expect(resp.error).to.be('success')
        done()

