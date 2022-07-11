-- ROBLOX upstream: no upstream
return function()
	local Packages = script.Parent.Parent.Parent

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local querySelectorsModule = require(script.Parent.Parent.querySelectors)
	local querySelector = querySelectorsModule.querySelector
	local querySelectorAll = querySelectorsModule.querySelectorAll

	describe("querySelectorAll", function()
		it("gets all descendants when pattern is .", function()
			local div = Instance.new("Frame")
			local label1 = Instance.new("TextLabel")
			label1.Parent = div
			local button1 = Instance.new("TextButton")
			button1.Parent = div
			local label2 = Instance.new("TextLabel")
			label2.Parent = div
			local label3 = Instance.new("TextLabel")
			label3.Parent = div
			local elements = querySelectorAll(div, { "." })
			jestExpect(#elements).toBe(4)
			jestExpect(elements).toEqual({ label1, button1 :: any, label2, label3 })
		end)

		it("gets descendants matching array of patterns", function()
			local div = Instance.new("Frame")
			local label1 = Instance.new("TextLabel")
			label1.Parent = div
			local button1 = Instance.new("TextButton")
			button1.Parent = div
			local label2 = Instance.new("TextLabel")
			label2.Parent = div
			local label3 = Instance.new("TextLabel")
			label3.Parent = div
			jestExpect(#querySelectorAll(div, { "TextLabel" })).toBe(3)
			jestExpect(querySelectorAll(div, { "TextLabel" })).toEqual({ label1, label2, label3 })
			jestExpect(#querySelectorAll(div, { "TextButton" })).toBe(1)
			jestExpect(querySelectorAll(div, { "TextButton" })).toEqual({ button1 })
		end)
	end)

	describe("querySelector", function()
		it("gets first descendant when pattern is .", function()
			local div = Instance.new("Frame")
			local label1 = Instance.new("TextLabel")
			label1.Parent = div
			local button1 = Instance.new("TextButton")
			button1.Parent = div
			local label2 = Instance.new("TextLabel")
			label2.Parent = div
			local label3 = Instance.new("TextLabel")
			label3.Parent = div
			jestExpect(querySelector(div, { "." })).toBe(label1)
		end)

		it("gets first descendant matching array of patterns", function()
			local div = Instance.new("Frame")
			local label1 = Instance.new("TextLabel")
			label1.Parent = div
			local button1 = Instance.new("TextButton")
			button1.Parent = div
			local label2 = Instance.new("TextLabel")
			label2.Parent = div
			local label3 = Instance.new("TextLabel")
			label3.Parent = div
			jestExpect(querySelector(div, { "TextLabel" })).toBe(label1)
			jestExpect(querySelector(div, { "TextButton" })).toBe(button1)
			jestExpect(querySelector(div, { "TextLabel", "TextButton" })).toBe(label1)
			jestExpect(querySelector(div, { "TextButton", "TextLabel" })).toBe(label1)
		end)
	end)
end
