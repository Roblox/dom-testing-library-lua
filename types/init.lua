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
local prettyDomModule = require(script["pretty-dom"])
export type PrettyDOMOptions = prettyDomModule.PrettyDOMOptions
export type prettyDOM = (dom: Instance?, maxLength: number?, options: PrettyDOMOptions?) -> string | false
export type logDOM = (dom: Instance?, maxLength: number?, options: PrettyDOMOptions?) -> ()
export type Colors = prettyDomModule.Colors
export type CompareKeys = prettyDomModule.CompareKeys
-- export type Config = prettyDomModule.Config
export type Options = prettyDomModule.Options
export type OptionsReceived = prettyDomModule.OptionsReceived
export type OldPlugin = prettyDomModule.OldPlugin
export type NewPlugin = prettyDomModule.NewPlugin
export type Plugin = prettyDomModule.Plugin
export type Plugins = prettyDomModule.Plugins
export type PrettyFormatOptions = prettyDomModule.PrettyFormatOptions
export type Printer = prettyDomModule.Printer
export type Refs = prettyDomModule.Refs
export type Theme = prettyDomModule.Theme
-- Object.assign(exports, require(script["role-helpers"]))
local configModule = require(script.config)
export type Config = configModule.Config
export type ConfigFn = configModule.ConfigFn
export type configure = configModule.configure
export type getConfig = configModule.getConfig
-- Object.assign(exports, require(script.suggestions))

local getNodeTextModule = require(script["get-node-text"])
export type getNodeText = getNodeTextModule.getNodeText

return exports
