-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/src/get-queries-for-element.js
local Packages = script.Parent.Parent

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
type Array<T> = LuauPolyfill.Array<T>
type Object = LuauPolyfill.Object

local exports = {}

local defaultQueries = require(script.Parent.queries)

--[[*
 	* @typedef {{[key: string]: Function}} FuncMap
]]

--[[*
 	* @param {HTMLElement} element container
 	* @param {FuncMap} queries object of functions
 	* @param {Object} initialValue for reducer
 	* @returns {FuncMap} returns object of functions bound to container
]]
local function getQueriesForElement(element: Instance, queries_: any?, initialValue: Object?)
	local queries = (if queries_ == nil then defaultQueries else queries_) :: Object

	if initialValue == nil then
		initialValue = {}
	end
	return Array.reduce(Object.keys(queries :: Object), function(helpers, key: string)
		local fn = queries[key]
		helpers[key] = function(...)
			return fn(element, ...)
		end
		return helpers
	end, initialValue :: Object)
end
exports.getQueriesForElement = getQueriesForElement

return exports
