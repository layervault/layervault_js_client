expect  = require 'expect.js'
nock    = require 'nock'

LayerVault = require '../../lib/layervault'

describe 'Revision', ->
  before ->
    @config = new LayerVault.Configuration ->
      @accessToken = 'foobar'
      @refreshToken = 'barfoo'

    @client = new LayerVault.Client(@config)
    @organization = @client.organization('ryan-lefevre')

  beforeEach -> @revision = @organization.revision('Test Project', 'test.psd', 1)
  afterEach -> nock.cleanAll()

  describe 'get', ->
    beforeEach ->
      nock(@config.apiBase)
        .get("#{@config.apiPath}#{@revision.nodePath}")
        .reply(200, require('../fixtures/revision/get'))

    it 'does not error', (done) ->
      @revision.get (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns a response object', (done) ->
      @revision.get (err, resp) ->
        expect(resp).to.not.be(null)
        expect(resp.name).to.be('1')
        done()

    it 'applied the data to the object', (done) ->
      @revision.get (err, resp) ->
        expect(@name).to.be('1')
        expect(@revision_number).to.be(1)
        done()

  describe 'preview', ->
    beforeEach ->
      @previewUrl = 'https://layervault-preview.imgix.net/preview.jpg'

    it 'does not error'
    it 'returns a response'

  describe 'previews', ->
    beforeEach ->
      @previewUrls = ['https://layervault-preview.imgix.net/preview.jpg']

    it 'does not error'
    it 'returns an array response'

  describe 'meta', ->
    beforeEach ->
      nock(@config.apiBase)
        .get("#{@config.apiPath}#{@revision.nodePath}/meta")
        .reply(200, require('../fixtures/revision/meta'))

    it 'does not error', (done) ->
      @revision.meta (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns a response', (done) ->
      @revision.meta (err, resp) ->
        expect(resp).to.not.be(null)
        expect(resp.psd).to.be.an('object')
        done()

  describe 'feedback items', ->
    beforeEach ->
      nock(@config.apiBase)
        .get("#{@config.apiPath}#{@revision.nodePath}/feedback_items")
        .reply(200, require('../fixtures/revision/feedback_items'))

    it 'does not error', (done) ->
      @revision.feedbackItems (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns an array response', (done) ->
      @revision.feedbackItems (err, resp) ->
        expect(resp).to.be.an('array')
        expect(resp.length).to.be(1)
        expect(resp[0].id).to.be(1)
        done()

    it 'is aliased to #feedback', (done) ->
      @revision.feedback (err, resp) ->
        expect(err).to.be(null)
        expect(resp).to.be.an('array')
        done()

    describe 'with a promise', ->
      it 'resolves', (done) ->
        @revision.feedbackItems().then (resp) ->
          expect(resp).to.be.an('array')
          expect(resp.length).to.be(1)
          done()