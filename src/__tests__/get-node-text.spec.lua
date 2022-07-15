-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/src/__tests__/get-node-text.js
return function()
	local Packages = script.Parent.Parent.Parent
	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local getNodeText = require(script.Parent.Parent["get-node-text"]).getNodeText
	local render = require(script.Parent.helpers["test-utils"])(afterEach).render

	--[[
		ROBLOX deviation START:
		No matching upstream test since we are testing using Roblox components rather than HTML elements
		TextNode equivalent is non existent
	]]
	it("it prints out the text content of a container's children and descendants", function()
		local TextLabel = Instance.new("TextLabel")
		TextLabel.Text = "TextLabel text!"
		local TextButton = Instance.new("TextButton")
		TextButton.Text = "TextButton text!"
		local TextBox = Instance.new("TextBox")
		TextBox.Text = "TextBox text!"

		local container: Frame = render({
			TextLabel,
			TextButton,
			TextBox,
		}).container

		local children = container:GetChildren()

		jestExpect(getNodeText(container)).toBe("")
		jestExpect(getNodeText(children[1])).toBe("TextLabel text!")
		jestExpect(getNodeText(children[2])).toBe("TextButton text!")
		jestExpect(getNodeText(children[3])).toBe("")
	end)
	-- ROBLOX deviation END
end
