-- ROBLOX upstream: no upstream
return function()
	local Packages = script.Parent.Parent.Parent

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local setTimeout = LuauPolyfill.setTimeout

	local Promise = require(Packages.Promise)

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local domTestingModule = require(script.Parent.Parent)
	local fireEvent, getByPlaceholderText, getByText, getByTestId, queryByTestId, waitFor =
		domTestingModule.fireEvent,
		domTestingModule.getByPlaceholderText,
		domTestingModule.getByText,
		domTestingModule.getByTestId,
		domTestingModule.queryByTestId,
		domTestingModule.waitFor

	local querySelector = require(Packages.JsHelpers.querySelectors).querySelector

	local function getExampleDOM()
		local div = Instance.new("Frame")
		local input_ = Instance.new("TextBox")
		input_.PlaceholderText = "Username"
		local button_ = Instance.new("TextButton")
		button_.Text = "Print Username"

		input_.Parent = div
		button_.Parent = div

		local button = querySelector(div, { "TextButton" }) :: TextButton
		local input = querySelector(div, { "TextBox" }) :: TextBox

		button.Activated:Connect(function(_input)
			setTimeout(function()
				local printedUsernameContainer = Instance.new("Frame")
				local inner = Instance.new("TextLabel")
				inner:SetAttribute("data-testid", "printed-username")
				inner.Text = input.Text
				inner.Parent = printedUsernameContainer
				printedUsernameContainer.Parent = div
			end, math.floor(math.random() * 200))
		end)
		return div
	end

	it("examples of some things", function()
		-- ROBLOX comment: based on https://testing-library.com/docs/dom-testing-library/example-intro
		Promise.resolve()
			:andThen(function()
				local famousProgrammerInHistory = "Ada Lovelace"
				local container = getExampleDOM()

				local input = getByPlaceholderText(container, "Username")
				input.Text = famousProgrammerInHistory

				fireEvent(getByText(container, "Print Username"), "click")

				waitFor(function()
					return jestExpect(queryByTestId(container, "printed-username")).toBeTruthy()
				end):expect()

				jestExpect(getByTestId(container, "printed-username").Text).toBe(famousProgrammerInHistory)
			end)
			:expect()
	end)
end
