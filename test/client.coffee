expect  = require 'expect.js'
nock    = require 'nock'

LayerVault = require '../lib/layervault'

describe 'Client', ->
  before ->
    @config = new LayerVault.Configuration ->
      @accessToken = 'foobar'

  afterEach -> nock.cleanAll()

  it 'exists on the LayerVault object', ->
    expect(LayerVault).to.have.property('Client')
    expect(LayerVault.Client).to.not.be(null)

  it 'is initialized properly with a Configuration', ->
    client = new LayerVault.Client(@config)
    expect(client.config).to.be(@config)
    expect(client.auth).to.be.an('object')
    expect(client.api).to.be.an('object')
    expect(client.nodePath).to.be('')

  it 'can create a new Organization', ->
    client = new LayerVault.Client(@config)
    org = client.organization('foobar')

    expect(org).to.be.an('object')
    expect(org.get).to.be.a('function')

  describe 'can fetch the current user', ->
    before ->
      @client = new LayerVault.Client(@config)
      nock(@config.apiBase)
        .get("#{@config.apiPath}/me")
        .reply 200,
          id: 1,
          email: 'sloth@layervault.com'

    it 'successfully', (done) ->
      @client.me (err, resp) ->
        expect(err).to.be(null)
        expect(resp).to.be.an('object')
        expect(resp.id).to.be(1)
        expect(resp.email).to.be('sloth@layervault.com')
        done()

