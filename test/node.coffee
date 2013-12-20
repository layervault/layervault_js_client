expect  = require 'expect.js'
nock    = require 'nock'

LayerVault = require '../lib/layervault'
Node       = require '../lib/layervault/node'

describe 'Node', ->
  before ->
    @config = new LayerVault.Configuration ->
      @accessToken = 'foobar'

    @client = new LayerVault.Client(@config)
    @organization = @client.organization('ryan-lefevre')

  describe 'Initialization', ->
    it 'can be given an absolute path to the node', ->
      node = new Node(@client.api, '/path/to/node.psd')
      expect(node.nodeName).to.be('node.psd')
      expect(node.nodePath).to.be('/path/to/node.psd')

    it 'can be given a node name and a parent node', ->
      node = new Node(@client.api, @organization, 'node.psd')
      expect(node.nodeName).to.be('node.psd')
      expect(node.nodePath).to.be('/ryan-lefevre/node.psd')

    it 'can be given a node object and a parent node', ->
      node = new Node(@client.api, @organization, @organization.folder('Cool'))
      expect(node.nodeName).to.be('Cool')
      expect(node.nodePath).to.be('/ryan-lefevre/Cool')

    it 'can be given a parent node and multiple arguments for the path', ->
      node = @organization.folder('Really', 'Cool', 'Folder')
      expect(node.nodeName).to.be('Folder')
      expect(node.nodePath).to.be('/ryan-lefevre/Really/Cool/Folder')