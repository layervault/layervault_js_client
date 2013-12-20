expect  = require 'expect.js'

Md5Service = require '../../lib/layervault/services/md5'

describe 'Md5Service', ->
  before ->
    @file = './test/fixtures/file/file.txt'
    @expectedMd5 = '0507dee9c033cd8d901950cdd1a23676'

  it 'accepts a file', ->
    service = new Md5Service(@file)
    expect(service.file).to.be(@file)

  it 'correctly calculates the MD5 of the file', (done) ->
    service = new Md5Service(@file)
    service.calculate (md5) =>
      expect(md5).to.be(@expectedMd5)
      done()