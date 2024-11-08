-- ROBLOX upstream: no upstream
local Packages = script.Parent.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
type Array<T> = LuauPolyfill.Array<T>

-- ROBLOX deviation START: helper method
local getNodeTestId = require(script.Parent.Parent["get-node-test-id"]).getNodeTestId
-- ROBLOX deviation END

local exports = {}

type SelectorType = "property" | "attribute" | "tag"

local function matches(instance: Instance, patterns: Array<string>, type_: SelectorType?)
	return Array.some(patterns, function(pattern)
		if not type_ then
			return instance.ClassName:find(pattern) ~= nil
		elseif type_ == "property" then
			-- ROBLOX FIXME Luau: will complain when accessing with an indexed property
			local _, res = pcall(function()
				return (instance :: any)[pattern]
			end)
			return res ~= nil
		elseif type_ == "tag" then
			return getNodeTestId(instance) ~= nil
		else
			return instance:GetAttribute(pattern) ~= nil
		end
	end)
end

local function getDescendantsMatching(instance: Instance, patterns: Array<string>, type_: SelectorType?, max: number?)
	local matchesResult = {}

	for _, descendant in instance:GetDescendants() do
		if not matches(descendant, patterns, type_) then
			continue
		end

		if max == 1 then
			return descendant
		end

		table.insert(matchesResult, descendant)
		if max == #matchesResult then
			return matchesResult
		end
	end

	return matchesResult
end

exports.querySelector = function(instance: Instance, patterns: Array<string>, type_: SelectorType?)
	return getDescendantsMatching(instance, patterns, type_, 1) :: Instance?
end
exports.querySelectorAll = function(instance: Instance, patterns: Array<string>, type_: SelectorType?)
	return getDescendantsMatching(instance, patterns, type_) :: Array<Instance>
end
exports.matches = matches

return exports
