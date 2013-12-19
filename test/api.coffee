expect  = require 'expect.js'
nock    = require 'nock'

LayerVault = require '../lib/layervault'

describe 'API', ->
  before ->
    @config = new LayerVault.Configuration ->
      @accessToken = 'abc123'

    @client = new LayerVault.Client(@config)
    @api = @client.api

  it 'is initialized with a configuration', ->
    expect(@client.api.config).to.be(@config)

  describe 'GET', ->
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

