local Root = game:GetService("ReplicatedStorage")
local Packages = Root.Packages

local runCLI = require(Packages.Dev.Jest).runCLI

local processServiceExists, ProcessService = pcall(function()
	return game:GetService("ProcessService")
end)


local status, result = runCLI(Root, {
	verbose = _G.verbose == "true",
	ci = _G.CI == "true",
	updateSnapshot = _G.UPDATESNAPSHOT == "true",
}, { Packages.DomTestingLibrary }):awaitStatus()

if status == "Rejected" then
	print(result)
end

if status == "Resolved" and result.results.numFailedTestSuites == 0 and result.results.numFailedTests == 0 then
	if processServiceExists then
		ProcessService:ExitAsync(0)
	end
end

if processServiceExists then
	ProcessService:ExitAsync(1)
end


return nil
