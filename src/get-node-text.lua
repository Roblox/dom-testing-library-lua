-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/src/get-node-text.ts
local Packages = script.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local exports = {}

-- ROBLOX deviation START: Helper function to allow us to check if a node contains a Text key (Object.keys was not working for the same)
local function hasText(node: Instance)
	return (node :: any).Text
end
-- ROBLOX deviation END

local function getNodeText(node: Instance): string
	-- ROBLOX deviation START: Checking whether the node table contains a 'Text' key
	local ok = pcall(hasText, node)
	local text = if ok then (node :: any).Text else ""

	local children = node:GetChildren()

	return text
		.. Array.join(
			Array.map(children, function(childWithText: Instance)
				-- ROBLOX NOTE: We don't have access to textContent in Roblox, using recursive call to traverse the Roblox element tree and extract text
				return getNodeText(childWithText)
			end),
			""
		)
	-- ROBLOX deviation END
end

exports.getNodeText = getNodeText
return exports
