-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/src/__tests__/get-queries-for-element.js
return function()
	local Packages = script.Parent.Parent.Parent

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Object = LuauPolyfill.Object

	local document = require(Packages.JsHelpers.document)

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local jest = JestGlobals.jest

	local getQueriesForElement = require(script.Parent.Parent["get-queries-for-element"]).getQueriesForElement
	local queries = require(script.Parent.Parent.queries)

	it("uses default queries", function()
		local container = Instance.new("Frame")
		container.Parent = document
		local boundQueries = getQueriesForElement(container)
		jestExpect(Object.keys(boundQueries)).toEqual(Object.keys(queries))
	end)

	it("accepts custom queries", function()
		local container = Instance.new("Frame")
		container.Parent = document
		local customQuery = jest.fn()
		local boundQueries = getQueriesForElement(container, Object.assign({}, queries, { customQuery = customQuery }))
		jestExpect(boundQueries.customQuery).toBeDefined()
	end)

	it("binds functions to container", function()
		local container = Instance.new("Frame")
		container.Parent = document
		local mock = jest.fn()
		local function customQuery(element)
			return mock(element)
		end
		local boundQueries = getQueriesForElement(container, { customQuery = customQuery })
		boundQueries.customQuery()
		jestExpect(mock).toHaveBeenCalledWith(container)
	end)
end
