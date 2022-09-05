-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/tests/setup-env.js

local Packages = script.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local console = LuauPolyfill.console
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

local JestGlobals = require(Packages.JestGlobals)
local jest = JestGlobals.jest
local expect = JestGlobals.expect
local afterAll = JestGlobals.afterAll
local afterEach = JestGlobals.afterEach
local beforeAll = JestGlobals.beforeAll

-- ROBLOX deviation START: explicitly extend expect
local jestDomMatchers = require(Packages.DomTestingLibrary.jsHelpers["jest-dom"])
expect.extend(jestDomMatchers)
-- ROBLOX deviation END

-- local jestSnapshotSerializerAnsi = require(Packages["jest-snapshot-serializer-ansi"]).default
-- expect:addSnapshotSerializer(jestSnapshotSerializerAnsi) -- add serializer for MutationRecord
expect.addSnapshotSerializer({
	print = function(record, serialize)
		return serialize({
			addedNodes = record.addedNodes,
			attributeName = record.attributeName,
			attributeNamespace = record.attributeNamespace,
			nextSibling = record.nextSibling,
			oldValue = record.oldValue,
			previousSibling = record.previousSibling,
			removedNodes = record.removedNodes,
			target = record.target,
			type = record.type,
		})
	end,
	test = function(value)
		-- list of records will stringify to the same value
		return Array.isArray(value) == false and tostring(value) == "[object MutationRecord]"
	end,
})

-- ROBLOX deviation START: replace spyOn with jest.fn
local originalWarn = console.warn
local warnMock
beforeAll(function()
	warnMock = jest.fn(function(
		...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
	)
		local args = table.pack(...)
		if Boolean.toJSBoolean(args[1]) and string.find(tostring(args[1]), "deprecated") ~= nil then
			return
		end
		originalWarn(table.unpack(args))
	end)
	console.warn = warnMock
end)
-- ROBLOX deviation END

afterEach(function()
	-- ROBLOX deviation START: use different way to check if timers are mocked
	local ok = pcall(jest.getTimerCount)
	if ok then
		jest.useRealTimers()
	end
	-- ROBLOX deviation END
end)

afterAll(function()
	-- ROBLOX deviation START: replace spyOn with jest.fn
	warnMock:mockRestore()
	console.warn = originalWarn
	-- ROBLOX deviation END
end)

return {}
