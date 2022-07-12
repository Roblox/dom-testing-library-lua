-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/src/__tests__/query-helper.js
return function()
	local Packages = script.Parent.Parent.Parent

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local jest = JestGlobals.jest

	local queryHelpers = require(script.Parent.Parent["query-helpers"])
	local configModule = require(script.Parent.Parent.config)
	local configure = configModule.configure
	local getConfig = configModule.getConfig

	local originalConfig = getConfig()
	beforeEach(function()
		configure(originalConfig)
	end)

	afterEach(function()
		configure(originalConfig)
	end)

	it("should delegate to config.getElementError", function()
		local getElementError = jest.fn()
		configure({ getElementError = getElementError })

		local message = "test Message"
		local container = {} -- dummy

		queryHelpers.getElementError(message, container :: any)
		jestExpect(getElementError.mock.calls[1]).toEqual({ message, container :: any })
	end)
end
