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