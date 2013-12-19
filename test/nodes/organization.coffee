expect  = require 'expect.js'
nock    = require 'nock'

LayerVault = require '../../lib/layervault'

describe 'Organization', ->
  before ->
    @config = new LayerVault.Configuration ->
      @accessToken = 'foobar'

    @client = new LayerVault.Client(@config)
    @organization = @client.organization('ryan-lefevre')

  describe 'get', ->
    beforeEach ->
      nock(@config.apiBase)
        .get("#{@config.apiPath}#{@organization.nodePath}")
        .reply(200, require('../fixtures/organization/get'))

    it 'does not error', (done) ->
      @organization.get (err, resp) ->
        expect(err).to.be(null)
        done()

    it 'returns a repsonse object', (done) ->
      @organization.get (err, resp) ->
        expect(resp).to.be.an 'object'
        expect(resp.name).to.be 'Ryan LeFevre'
        expect(resp.permalink).to.be 'ryan-lefevre'
        expect(resp.projects.length).to.be 1
        done()

    it 'applies the data to the organization object', (done) ->
      organization = @organization
      @organization.get (err, resp) ->
        expect(@permalink).to.be('ryan-lefevre')
        expect(@projects.length).to.be(1)
        expect(organization.permalink).to.be('ryan-lefevre')
        done()

    it 'correctly initializes relations', (done) ->
      @organization.get (err, resp) ->
        expect(@projects[0]).to.have.property('nodePath')
        expect(@projects[0].get).to.be.a('function')
        expect(@projects[0].name).to.be('Test Project')
        expect(@projects[0].nodePath).to.be("#{@nodePath}/Test%20Project")
        done()
