-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/src/index.js
local Packages = script.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

local exports = {}

local getQueriesForElement = require(script["get-queries-for-element"]).getQueriesForElement
local queries = require(script.queries)
local queryHelpers = require(script["query-helpers"])

Object.assign(exports, require(script.queries))
Object.assign(exports, require(script["wait-for"]))
Object.assign(exports, require(script["wait-for-element-to-be-removed"]))
exports.getDefaultNormalizer = require(script.matches).getDefaultNormalizer
Object.assign(exports, require(script["get-node-text"]))
-- Object.assign(exports, require(script.events))
Object.assign(exports, require(script["get-queries-for-element"]))
Object.assign(exports, require(script.screen))
Object.assign(exports, require(script["query-helpers"]))
-- local role_helpersModule = require(script["role-helpers"])
-- exports.getRoles = role_helpersModule.getRoles
-- exports.logRoles = role_helpersModule.logRoles
-- exports.isInaccessible = role_helpersModule.isInaccessible
Object.assign(exports, require(script["pretty-dom"]))
local configModule = require(script.config)
exports.configure = configModule.configure
exports.getConfig = configModule.getConfig
-- Object.assign(exports, require(script.suggestions))

-- "within" reads better in user-code
-- "getQueriesForElement" reads better in library code
-- so we have both
exports.within = getQueriesForElement
-- export query utils under a namespace for convenience:
exports.queries = queries
exports.queryHelpers = queryHelpers

return exports
