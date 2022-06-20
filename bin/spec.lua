local ProcessService = game:GetService("ProcessService")
local Root = game:GetService("ReplicatedStorage")

local Packages = Root.Packages
-- Load JestGlobals source into Packages folder so it's next to Roact as expected
local TestEZ = require(Root.Packages.Dev.JestGlobals).TestEZ

-- Run all tests, collect results, and report to stdout.
local result = TestEZ.TestBootstrap:run(
	{ Packages.DomTestingLibrary },
	TestEZ.Reporters.TextReporterQuiet
)

if result.failureCount == 0 and #result.errors == 0 then
	ProcessService:ExitAsync(0)
else
	ProcessService:ExitAsync(1)
end
