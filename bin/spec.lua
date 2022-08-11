local Root = game:GetService("ReplicatedStorage")
local Packages = Root.Packages

local runCLI = require(Packages.JestCore).runCLI

local status, result = runCLI(Root, {
	verbose = _G.verbose == "true",
	ci = _G.CI == "true",
	updateSnapshot = _G.UPDATESNAPSHOT == "true",
}, { Packages.DomTestingLibrary }):awaitStatus()

if status == "Rejected" then
	print(result)
end

return nil
