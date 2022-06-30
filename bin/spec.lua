local Root = game:GetService("ReplicatedStorage")

local Packages = Root.Packages

local JestGlobals = require(Packages.Dev.JestGlobals)

local TestEZ = JestGlobals.TestEZ

-- Run all tests, collect results, and report to stdout.
TestEZ.TestBootstrap:run(
	{ Packages.DomTestingLibrary, Packages.JsHelpers },
	TestEZ.Reporters.pipe({
		TestEZ.Reporters.JestDefaultReporter,
		TestEZ.Reporters.JestSummaryReporter,
	}),
	{
		extraEnvironment = JestGlobals.testEnv,
	}
)
-- ROBLOX TODO: after converting jest-runner this should be included there
JestGlobals.runtime:teardown()

return nil
