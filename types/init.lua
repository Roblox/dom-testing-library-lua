-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/types/index.d.ts

local exports = {}
-- TypeScript Version: 3.8

-- local getQueriesForElement = require(script["get-queries-for-element"]).getQueriesForElement
-- local queries = require(script.queries)
-- local queryHelpers = require(script["query-helpers"])
-- local within: typeof(getQueriesForElement)

-- exports.queries = queries
-- exports.queryHelpers = queryHelpers
-- exports.within = within
-- Object.assign(exports, require(script.queries))
-- Object.assign(exports, require(script["query-helpers"]))
-- Object.assign(exports, require(script.screen))
-- Object.assign(exports, require(script["wait-for"]))
local waitForModule = require(script["wait-for"])
export type waitForOptions = waitForModule.waitForOptions
export type waitFor = waitForModule.waitFor
-- Object.assign(exports, require(script["wait-for-element-to-be-removed"]))
local matchesModule = require(script.matches)
export type MatcherFunction = matchesModule.MatcherFunction
export type Matcher = matchesModule.Matcher
export type ByRoleMatcher = matchesModule.ByRoleMatcher
export type NormalizerFn = matchesModule.NormalizerFn
export type NormalizerOptions = matchesModule.NormalizerOptions
export type MatcherOptions = matchesModule.MatcherOptions
export type Match = matchesModule.Match
export type DefaultNormalizerOptions = matchesModule.DefaultNormalizerOptions
export type getDefaultNormalizer = matchesModule.getDefaultNormalizer
-- Object.assign(exports, require(script["get-node-text"]))
-- Object.assign(exports, require(script.events))
-- Object.assign(exports, require(script["get-queries-for-element"]))
-- Object.assign(exports, require(script["pretty-dom"]))
-- Object.assign(exports, require(script["role-helpers"]))
-- Object.assign(exports, require(script.config))
-- Object.assign(exports, require(script.suggestions))

return exports
