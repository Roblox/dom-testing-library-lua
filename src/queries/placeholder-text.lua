-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/src/queries/placeholder-text.ts
local Packages = script.Parent.Parent.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
type Array<T> = LuauPolyfill.Array<T>

type unknown = any --[[ ROBLOX FIXME: adding `unknown` type alias to make it easier to use Luau unknown equivalent when supported ]]

local exports = {}

local wrapAllByQueryWithSuggestion = require(script.Parent.Parent["query-helpers"]).wrapAllByQueryWithSuggestion
local checkContainerType = require(script.Parent.Parent.helpers).checkContainerType
local typesModule = require(Packages.Types)
type AllByBoundAttribute<T = Instance> = typesModule.AllByBoundAttribute<T>
-- ROBLOX FIXME: use correct type when available
-- type GetErrorFunction<T> = typesModule.GetErrorFunction<T>
type GetErrorFunction<T> = any
local all_utilsModule = require(script.Parent["all-utils"])
local queryAllByAttribute = all_utilsModule.queryAllByAttribute
local buildQueries = all_utilsModule.buildQueries

local queryAllByPlaceholderText: AllByBoundAttribute
function queryAllByPlaceholderText(...: any)
	local args = { ... }
	checkContainerType(args[1])
	--[[ ROBLOX TODO:
		 PlaceholderText is a property,
		 We may require a queryAllByProperty method.
		 Let's wait for query-helpers to be merged
	]]
	return queryAllByAttribute("PlaceholderText", ...)
end

local getMultipleError: GetErrorFunction<Array<unknown>>
function getMultipleError(c, text)
	return ("Found multiple elements with the placeholder text of: %s"):format(tostring(text))
end
local getMissingError: GetErrorFunction<Array<unknown>>
function getMissingError(c, text)
	return ("Unable to find an element with the placeholder text of: %s"):format(tostring(text))
end

local queryAllByPlaceholderTextWithSuggestions = wrapAllByQueryWithSuggestion(
	queryAllByPlaceholderText,
	debug.info(queryAllByPlaceholderText, "n"),
	"queryAll"
)

local queryByPlaceholderText, getAllByPlaceholderText, getByPlaceholderText, findAllByPlaceholderText, findByPlaceholderText =
	table.unpack(
		buildQueries(queryAllByPlaceholderText, getMultipleError, getMissingError),
		1,
		5
	)

exports.queryByPlaceholderText = queryByPlaceholderText
exports.queryAllByPlaceholderText = queryAllByPlaceholderTextWithSuggestions
exports.getByPlaceholderText = getByPlaceholderText
exports.getAllByPlaceholderText = getAllByPlaceholderText
exports.findAllByPlaceholderText = findAllByPlaceholderText
exports.findByPlaceholderText = findByPlaceholderText

return exports