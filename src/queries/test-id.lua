-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/src/queries/test-id.ts
local Packages = script.Parent.Parent.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
type Array<T> = LuauPolyfill.Array<T>

type unknown = any --[[ ROBLOX FIXME: adding `unknown` type alias to make it easier to use Luau unknown equivalent when supported ]]

local exports = {}

local checkContainerType = require(script.Parent.Parent.helpers).checkContainerType
-- ROBLOX FIXME: use module when ready
-- local wrapAllByQueryWithSuggestion = require(script.Parent.Parent["query-helpers"]).wrapAllByQueryWithSuggestion
local wrapAllByQueryWithSuggestion = function<Arguments>(fn, ...)
	return fn
end

local typesModule = require(Packages.Types)
type AllByBoundAttribute<T = Instance> = typesModule.AllByBoundAttribute<T>

-- ROBLOX FIXME: use correct type when available
-- type GetErrorFunction<T> = typesModule.GetErrorFunction<T>
type GetErrorFunction<T> = any

local all_utilsModule = require(script.Parent["all-utils"])
local queryAllByAttribute = all_utilsModule.queryAllByAttribute
local getConfig = all_utilsModule.getConfig
-- ROBLOX FIXME: pending implementation
-- local buildQueries = all_utilsModule.buildQueries
local buildQueries = function(...)
	return {}
end

local function getTestIdAttribute()
	return getConfig().testIdAttribute
end

local queryAllByTestId: AllByBoundAttribute
function queryAllByTestId(...: any)
	local args = { ... }
	checkContainerType(args[1])
	return queryAllByAttribute(getTestIdAttribute(), ...)
end

local getMultipleError: GetErrorFunction<Array<unknown>>
function getMultipleError(c, id)
	return ('Found multiple elements by: [%s="%s"]'):format(getTestIdAttribute(), tostring(id))
end
local getMissingError: GetErrorFunction<Array<unknown>>
function getMissingError(c, id)
	return ('Unable to find an element by: [%s="%s"]'):format(getTestIdAttribute(), tostring(id))
end

local queryAllByTestIdWithSuggestions = wrapAllByQueryWithSuggestion(
	queryAllByTestId,
	debug.info(queryAllByTestId, "n"),
	"queryAll"
)

local queryByTestId, getAllByTestId, getByTestId, findAllByTestId, findByTestId = table.unpack(
	buildQueries(queryAllByTestId, getMultipleError, getMissingError),
	1,
	5
)

exports.queryByTestId = queryByTestId
exports.queryAllByTestId = queryAllByTestIdWithSuggestions
exports.getByTestId = getByTestId
exports.getAllByTestId = getAllByTestId
exports.findAllByTestId = findAllByTestId
exports.findByTestId = findByTestId

return exports
