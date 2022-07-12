-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/types/index.d.ts

local exports = {}
-- TypeScript Version: 3.8

-- local getQueriesForElement = require(script["get-queries-for-element"]).getQueriesForElement

-- local within: typeof(getQueriesForElement)

-- exports.within = within

local queriesModule = require(script.queries)
export type QueryByBoundAttribute<T = Instance> = queriesModule.QueryByBoundAttribute<T>
export type AllByBoundAttribute<T = Instance> = queriesModule.AllByBoundAttribute<T>
export type FindAllByBoundAttribute<T = Instance> = queriesModule.FindAllByBoundAttribute<T>
export type GetByBoundAttribute<T = Instance> = queriesModule.GetByBoundAttribute<T>
export type FindByBoundAttribute<T = Instance> = queriesModule.FindByBoundAttribute<T>
export type QueryByText<T = Instance> = queriesModule.QueryByText<T>
export type AllByText<T = Instance> = queriesModule.AllByText<T>
export type FindAllByText<T = Instance> = queriesModule.FindAllByText<T>
export type GetByText<T = Instance> = queriesModule.GetByText<T>
export type FindByText<T = Instance> = queriesModule.FindByText<T>
export type ByRoleOptions = queriesModule.ByRoleOptions
export type AllByRole<T = Instance> = queriesModule.AllByRole<T>
export type GetByRole<T = Instance> = queriesModule.GetByRole<T>
export type QueryByRole<T = Instance> = queriesModule.QueryByRole<T>
export type FindByRole<T = Instance> = queriesModule.FindByRole<T>
export type FindAllByRole<T = Instance> = queriesModule.FindAllByRole<T>
export type getByLabelText<T = Instance> = queriesModule.getByLabelText<T>
export type getAllByLabelText<T = Instance> = queriesModule.getAllByLabelText<T>
export type queryByLabelText<T = Instance> = queriesModule.queryByLabelText<T>
export type queryAllByLabelText<T = Instance> = queriesModule.queryAllByLabelText<T>
export type findByLabelText<T = Instance> = queriesModule.findByLabelText<T>
export type findAllByLabelText<T = Instance> = queriesModule.findAllByLabelText<T>
export type getByPlaceholderText<T = Instance> = queriesModule.getByPlaceholderText<T>
export type getAllByPlaceholderText<T = Instance> = queriesModule.getAllByPlaceholderText<T>
export type queryByPlaceholderText<T = Instance> = queriesModule.queryByPlaceholderText<T>
export type queryAllByPlaceholderText<T = Instance> = queriesModule.queryAllByPlaceholderText<T>
export type findByPlaceholderText<T = Instance> = queriesModule.findByPlaceholderText<T>
export type findAllByPlaceholderText<T = Instance> = queriesModule.findAllByPlaceholderText<T>
export type getByText<T = Instance> = queriesModule.getByText<T>
export type getAllByText<T = Instance> = queriesModule.getAllByText<T>
export type queryByText<T = Instance> = queriesModule.queryByText<T>
export type queryAllByText<T = Instance> = queriesModule.queryAllByText<T>
export type findByText<T = Instance> = queriesModule.findByText<T>
export type findAllByText<T = Instance> = queriesModule.findAllByText<T>
export type getByAltText<T = Instance> = queriesModule.getByAltText<T>
export type getAllByAltText<T = Instance> = queriesModule.getAllByAltText<T>
export type queryByAltText<T = Instance> = queriesModule.queryByAltText<T>
export type queryAllByAltText<T = Instance> = queriesModule.queryAllByAltText<T>
export type findByAltText<T = Instance> = queriesModule.findByAltText<T>
export type findAllByAltText<T = Instance> = queriesModule.findAllByAltText<T>
export type getByTitle<T = Instance> = queriesModule.getByTitle<T>
export type getAllByTitle<T = Instance> = queriesModule.getAllByTitle<T>
export type queryByTitle<T = Instance> = queriesModule.queryByTitle<T>
export type queryAllByTitle<T = Instance> = queriesModule.queryAllByTitle<T>
export type findByTitle<T = Instance> = queriesModule.findByTitle<T>
export type findAllByTitle<T = Instance> = queriesModule.findAllByTitle<T>
export type getByDisplayValue<T = Instance> = queriesModule.getByDisplayValue<T>
export type getAllByDisplayValue<T = Instance> = queriesModule.getAllByDisplayValue<T>
export type queryByDisplayValue<T = Instance> = queriesModule.queryByDisplayValue<T>
export type queryAllByDisplayValue<T = Instance> = queriesModule.queryAllByDisplayValue<T>
export type findByDisplayValue<T = Instance> = queriesModule.findByDisplayValue<T>
export type findAllByDisplayValue<T = Instance> = queriesModule.findAllByDisplayValue<T>
export type getByRole<T = Instance> = queriesModule.getByRole<T>
export type getAllByRole<T = Instance> = queriesModule.getAllByRole<T>
export type queryByRole<T = Instance> = queriesModule.queryByRole<T>
export type queryAllByRole<T = Instance> = queriesModule.queryAllByRole<T>
export type findByRole<T = Instance> = queriesModule.findByRole<T>
export type findAllByRole<T = Instance> = queriesModule.findAllByRole<T>
export type getByTestId<T = Instance> = queriesModule.getByTestId<T>
export type getAllByTestId<T = Instance> = queriesModule.getAllByTestId<T>
export type queryByTestId<T = Instance> = queriesModule.queryByTestId<T>
export type queryAllByTestId<T = Instance> = queriesModule.queryAllByTestId<T>
export type findByTestId<T = Instance> = queriesModule.findByTestId<T>
export type findAllByTestId<T = Instance> = queriesModule.findAllByTestId<T>

local queryHelpersModule = require(script["query-helpers"])
export type WithSuggest = queryHelpersModule.WithSuggest
export type GetErrorFunction<Argument = any> = queryHelpersModule.GetErrorFunction<Argument>
export type SelectorMatcherOptions = queryHelpersModule.SelectorMatcherOptions
export type QueryByAttribute = queryHelpersModule.QueryByAttribute
export type AllByAttribute = queryHelpersModule.AllByAttribute
export type queryByAttribute = queryHelpersModule.queryByAttribute
export type queryAllByAttribute = queryHelpersModule.queryAllByAttribute
export type getElementError = queryHelpersModule.getElementError
export type QueryMethod<Argument, Return> = queryHelpersModule.QueryMethod<Argument, Return>
export type QueryBy<Argument> = queryHelpersModule.QueryBy<Argument>
export type GetAllBy<Argument> = queryHelpersModule.GetAllBy<Argument>
export type FindAllBy<Argument> = queryHelpersModule.FindAllBy<Argument>
export type GetBy<Argument> = queryHelpersModule.GetBy<Argument>
export type FindBy<Argument> = queryHelpersModule.FindBy<Argument>
export type BuiltQueryMethods<Argument> = queryHelpersModule.BuiltQueryMethods<Argument>
export type buildQueries<Argument> = queryHelpersModule.buildQueries<Argument>

-- Object.assign(exports, require(script.screen))
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
local getQueriesForElementModule = require(script["get-queries-for-element"])
export type BoundFunction<T> = getQueriesForElementModule.BoundFunction<T>
export type BoundFunctions<Q> = getQueriesForElementModule.BoundFunctions<Q>
export type Query = getQueriesForElementModule.Query
export type Queries = getQueriesForElementModule.Queries
export type getQueriesForElement = getQueriesForElementModule.getQueriesForElement
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

local suggestionsModule = require(script.suggestions)

export type QueryOptions = suggestionsModule.QueryOptions
export type QueryArgs = suggestionsModule.QueryArgs
export type Suggestion = suggestionsModule.Suggestion
export type Variant = suggestionsModule.Variant
export type Method = suggestionsModule.Method
export type getSuggestedQuery = suggestionsModule.getSuggestedQuery

local getNodeTextModule = require(script["get-node-text"])
export type getNodeText = getNodeTextModule.getNodeText

return exports
