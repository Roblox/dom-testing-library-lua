-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/src/__tests__/config.js
return function()
	local Packages = script.Parent.Parent.Parent

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local configModule = require(script.Parent.Parent.config)
	local configure = configModule.configure
	local getConfig = configModule.getConfig

	describe("configuration API", function()
		local originalConfig
		beforeEach(function()
			-- Grab the existing configuration so we can restore
			-- it at the end of the test
			configure(function(existingConfig)
				originalConfig = existingConfig -- Don't change the existing config
				return {}
			end)
		end)
		afterEach(function()
			configure(originalConfig)
		end)
		beforeEach(function()
			configure({ other = 123 })
		end)
		describe("getConfig", function()
			it("returns existing configuration", function()
				local conf = getConfig()
				jestExpect(conf.testIdAttribute).toEqual("data-testid")
			end)
		end)
		describe("configure", function()
			it("merges a delta rather than replacing the whole config", function()
				local conf = getConfig()
				jestExpect(conf).toMatchObject({ testIdAttribute = "data-testid" })
			end)
			it("overrides existing values", function()
				configure({ testIdAttribute = "new-id" })
				local conf = getConfig()
				jestExpect(conf.testIdAttribute).toEqual("new-id")
			end)
			it("passes existing config out to config function", function()
				-- Create a new config key based on the value of an existing one
				configure(function(existingConfig)
					return {
						testIdAttribute = ("%s-derived"):format(tostring(existingConfig.testIdAttribute)),
					}
				end)
				local conf = getConfig() -- The new value should be there, and existing values should be
				-- untouched
				jestExpect(conf).toMatchObject({ testIdAttribute = "data-testid-derived" })
			end)
		end)
	end)
end
