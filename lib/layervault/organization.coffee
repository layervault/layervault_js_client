module.exports = class Organization
  constructor: (org, @api) ->
    @orgName = if typeof org is "object" then org.name else org

  node: (path, cb) -> @api.get @apiPath(path), {}, cb
  apiPath: (path) -> "/#{encodeURIComponent(@orgName)}/#{path}"