module.exports = class Organization
  constructor: (org, @api) ->
    @orgName = if typeof org is "object" then org.name else org

  node: (path, cb) ->
    @api.get @apiPath(path), {}, cb

  apiPath: (path) ->
    path = path.path || path.name if typeof path is "object"
    "/#{encodeURIComponent(@orgName)}/#{path}"