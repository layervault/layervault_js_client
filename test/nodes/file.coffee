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

    it 'returns a promise', ->
      promise = @file.create
        localPath: './test/fixtures/file/file.txt'
        contentType: 'application/json'

      expect(promise).to.have.property('then')
      expect(promise.then).to.be.a('function')

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

  describe 'move', ->
    beforeEach ->
      nock(@config.apiBase)
        .post("#{@config.apiPath}#{@file.nodePath}/move", to: 'Other Project')
        .reply(200, require('../fixtures/file/move'))

    it 'does not error', (done) ->
      @file.move to: 'Other Project', (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns a response object', (done) ->
      @file.move to: 'Other Project', (err, resp) ->
        expect(resp).to.not.be(null)
        expect(resp.name).to.be('test.psd')
        done()

    it 'updates the object with the new data', (done) ->
      @file.move to: 'Other Project', (err, resp) ->
        expect(@local_path).to.be('~/LayerVault/Other Project/test.psd')
        done()

  describe 'revisions', ->
    beforeEach ->
      nock(@config.apiBase)
        .get("#{@config.apiPath}#{@file.nodePath}/revisions")
        .reply(200, require('../fixtures/file/revisions'))

    it 'does not error', (done) ->
      @file.revisions (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns a response array', (done) ->
      @file.revisions (err, resp) ->
        expect(resp).to.be.an('array')
        expect(resp.length).to.be(2)
        done()

    it 'applies the data to the file object', (done) ->
      @file.revisions (err, resp) ->
        expect(@revisions).to.be.an('array')
        expect(@revisions.length).to.be(2)
        done()

    it 'correctly builds relations', (done) ->
      @file.revisions (err, resp) ->
        expect(@revisions[0].get).to.be.a('function')
        expect(@revisions[0].nodeName).to.be('1')
        done()

  describe 'preview', ->
    before ->
      @previewUrl = "https://layervault-preview.imgix.net/preview.jpg"

    describe 'without arguments', ->
      beforeEach ->
        nock(@config.apiBase)
          .get("#{@config.apiPath}#{@file.nodePath}/preview")
          .reply(200, @previewUrl)

      it 'does not error', (done) ->
        @file.preview (err, resp) ->
          expect(err).to.be(null)
          done()

      it 'returns a response', (done) ->
        @file.preview (err, resp) =>
          expect(resp).to.not.be(null)
          expect(resp.toString()).to.be(@previewUrl)
          done()

    describe 'with arguments', ->
      beforeEach ->
        nock(@config.apiBase)
          .get("#{@config.apiPath}#{@file.nodePath}/preview", {w: 20})
          .reply(200, @previewUrl)

      it 'does not error', (done) ->
        @file.preview {w: 20}, (err, resp) ->
          expect(err).to.be(null)
          done()

      it 'returns a response', (done) ->
        @file.preview {w: 20}, (err, resp) =>
          expect(resp).to.not.be(null)
          expect(resp.toString()).to.be(@previewUrl)
          done()

    describe 'with a promise', ->
      beforeEach ->
        nock(@config.apiBase)
          .get("#{@config.apiPath}#{@file.nodePath}/preview")
          .reply(200, @previewUrl)

      it 'resolves', (done) ->
        @file.preview().then (resp) ->
          expect(resp.toString()).to.be(@previewUrl)
          done()

      it 'resolves with arguments', (done) ->
        @file.preview(w: 20).then (resp) ->
          expect(resp.toString()).to.be(@previewUrl)
          done()
