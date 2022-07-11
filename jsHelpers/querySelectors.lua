-- ROBLOX upstream: no upstream
local Packages = script.Parent.Parent
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
type Array<T> = LuauPolyfill.Array<T>

local exports = {}

local function matches(instance: Instance, patterns: Array<string>)
	return Array.some(patterns, function(pattern)
		return instance.ClassName:find(pattern) ~= nil
	end)
end

local function getDescendantsMatching(instance: Instance, patterns: Array<string>, max: number?)
	local matchesResult = {}
	local children = instance:GetChildren()

	Array.forEach(children, function(child)
		if matches(child, patterns) then
			table.insert(matchesResult, child)
		end
		matchesResult = Array.concat(matchesResult, getDescendantsMatching(child, patterns, max))
	end)

	return if max
		then (if max == 1 then matchesResult[1] else Array.slice(matchesResult, 1, max + 1))
		else matchesResult
end

exports.querySelector = function(instance: Instance, patterns: Array<string>)
	return getDescendantsMatching(instance, patterns, 1) :: Instance?
end
exports.querySelectorAll = function(instance: Instance, patterns: Array<string>)
	return getDescendantsMatching(instance, patterns) :: Array<Instance>
end
exports.matches = matches

return exports
