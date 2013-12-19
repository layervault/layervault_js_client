expect = require 'expect.js'
LayerVault = require '../lib/layervault'

describe 'Configuration', ->
  it 'is a property of LayerVault', ->
    expect(LayerVault).to.have.property('Configuration')
    expect(LayerVault.Configuration).to.not.be(null)

  it 'is initialized with default values', ->
    config = new LayerVault.Configuration()
    expect(config.oauthKey).to.be(null)
    expect(config.oauthSecret).to.be(null)
    expect(config.accessToken).to.be(null)
    expect(config.refreshToken).to.be(null)
    expect(config.apiBase).to.be("https://api.layervault.com")
    expect(config.apiPath).to.be("/api/v1")

  it 'can be initialized with a callback', (done) ->
    config = new LayerVault.Configuration ->
      expect(this).to.have.property('oauthKey')
      done()

  it 'can be initialized using #setup()', (done) ->
    config = new LayerVault.Configuration()
    config.setup ->
      expect(this).to.have.property('oauthKey')
      done()