expect  = require 'expect.js'
nock    = require 'nock'

LayerVault = require '../lib/layervault'

describe 'API', ->
  before ->
    @config = new LayerVault.Configuration ->
      @oauthKey = 'abc123'
      @oauthSecret = 'def456'
      @accessToken = 'foobar'
      @refreshToken = 'barfoo'

    @client = new LayerVault.Client(@config)
    @api = @client.api

  afterEach -> nock.cleanAll()

  it 'is initialized with a configuration', ->
    expect(@client.api.config).to.be(@config)

  describe 'GET', ->
    describe 'promise', ->
      it 'returns a promise', ->
        nock(@config.apiBase)
          .get("#{@config.apiPath}/200")
          .reply(200, {
            foo: 'bar'
          })

        promise = @api.get '/200'

        expect(promise).to.have.property('then')
        expect(promise.then).to.be.a('function')

      it 'resolves successful promises correctly', (done) ->
        nock(@config.apiBase)
          .get("#{@config.apiPath}/200")
          .reply(200, {
            foo: 'bar'
          })

        @api.get('/200').then (resp) ->
          expect(resp).to.not.be(null)
          expect(resp.foo).to.be('bar')
          done()

      it 'resolves failed promises correctly', (done) ->
        nock(@config.apiBase)
          .get("#{@config.apiPath}/400")
          .reply(400, {
            foo: 'bar'
          })

        @api.get('/400').fail (resp) ->
          expect(resp).to.not.be(null)
          expect(resp.foo).to.be('bar')
          done()

    describe 'successful request', ->
      beforeEach ->
        nock(@config.apiBase)
          .get("#{@config.apiPath}/200")
          .reply(200, {
            foo: 'bar'
          })

      it 'has a null error', (done) ->
        @api.get '/200', {}, (err, resp) ->
          expect(err).to.be(null)
          done()

      it 'returns the response as an object', (done) ->
        @api.get '/200', {}, (err, resp) ->
          expect(resp).to.eql foo: 'bar'
          done()

    describe 'unsuccessful request', ->
      beforeEach ->
        nock(@config.apiBase)
          .get("#{@config.apiPath}/403")
          .reply(403, {
            foo: 'bar'
          })

      it 'has a non-null error', (done) ->
        @api.get '/403', {}, (err, resp) ->
          expect(err).to.not.be(null)
          expect(err).to.eql foo: 'bar'
          done()

      it 'has a null response', (done) ->
        @api.get '/403', {}, (err, resp) ->
          expect(resp).to.be(null)
          done()

  describe 'refreshing tokens', ->
    beforeEach ->
      nock(@config.apiBase)
        .get("#{@config.apiPath}/200")
        .reply(401, {
          error: 'invalid_request'
        })

      nock(@config.apiBase)
        .post('/oauth/token', {
          grant_type: 'refresh_token',
          client_id: @config.oauthKey,
          client_secret: @config.oauthSecret,
          refresh_token: @config.refreshToken
        })
        .reply(200, {
          access_token: 'newfoobar',
          refresh_token: 'newbarfoo'
        })

      nock(@config.apiBase)
        .get("#{@config.apiPath}/200")
        .reply(200, {
          foo: 'bar'
        })

    it 'for a GET request', (done) ->
      @api.get '/200', {}, (err, resp) ->
        expect(err).to.be(null)
        expect(resp).to.be.an('object')
        expect(resp.foo).to.be('bar')

        done()