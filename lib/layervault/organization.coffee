module.exports = class Organization
  constructor: (org, @api) ->
    @orgName = if typeof org is "object" then org.name else org

  node: (path..., cb) ->
    @api.get @apiPath(path), {}, cb

  apiPath: (path) ->
    compiledPath = []
    for p in path
      p = p.path || p.name if typeof p is "object"
      compiledPath.push p
    
    "/#{encodeURIComponent(@orgName)}/#{compiledPath.join('/')}"