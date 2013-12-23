expect  = require 'expect.js'
nock    = require 'nock'

LayerVault = require '../lib/layervault'

describe 'Authentication', ->
  before ->
    @username = 'sloth@layervault.com'
    @password = 'allhailthesloth'

    @config = new LayerVault.Configuration ->
      @oauthKey = 'abc123'
      @oauthSecret = 'def456'

    @client = new LayerVault.Client(@config)

  describe 'with correct username/password', ->
    beforeEach ->
      nock(@config.apiBase)
        .post('/oauth/token', {
          grant_type: 'password',
          username: @username,
          password: @password,
          client_id: @config.oauthKey,
          client_secret: @config.oauthSecret
        })
        .reply(200, {
          access_token: 'foobar',
          refresh_token: 'slothbar'
        })

    it 'returns credentials and updates the config', (done) ->
      @client.auth.withPassword @username, @password, (err, tokens) =>
        expect(@config.accessToken).to.not.be(null)
        expect(@config.refreshToken).to.not.be(null)
        expect(@config.accessToken).to.be(tokens.accessToken)
        expect(@config.refreshToken).to.be(tokens.refreshToken)
        done()

    it 'works with a promise', (done) ->
      @client.auth.withPassword(@username, @password).then (data) =>
        expect(data.accessToken).to.not.be(null)
        expect(data.refreshToken).to.not.be(null)
        expect(@config.accessToken).to.be(data.accessToken)
        expect(@config.refreshToken).to.be(data.refreshToken)
        done()

    it 'emits an authorized event', (done) ->
      @client.auth.on 'authorized', (tokens) ->
        expect(tokens).to.be.an('object')
        expect(tokens.accessToken).to.be(@config.accessToken)
        expect(tokens.refreshToken).to.be(@config.refreshToken)
        done()

      @client.auth.withPassword @username, @password

