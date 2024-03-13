-- ROBLOX upstream: No upstream
local Packages = script.Parent.Parent.Parent.Parent

local JestGlobals = require(Packages.JestGlobals)
local expect = JestGlobals.expect
local describe = JestGlobals.describe
local test = JestGlobals.test
local jest = JestGlobals.jest

local dispatchEvent = require(script.Parent.Parent.dispatchEvent)
describe("dispatchEvent", function()
	test("should trigger click event", function()
		local element = Instance.new("TextButton")
		element.Size = UDim2.new(0, 100, 0, 100)
		element.Text = "Click Me"

		local callbackFn = jest.fn()

		element.Activated:Connect(function(...)
			callbackFn(...)
		end)

		expect(callbackFn).toHaveBeenCalledTimes(0)
		dispatchEvent(element, "click")
		expect(callbackFn).toHaveBeenCalledTimes(1)
	end)

	test("should trigger tap event", function()
		local element = Instance.new("TextButton")
		element.Size = UDim2.new(0, 100, 0, 100)
		element.Text = "Tap Me"

		local callbackFn = jest.fn()

		element.Activated:Connect(function(...)
			callbackFn(...)
		end)

		expect(callbackFn).toHaveBeenCalledTimes(0)
		dispatchEvent(element, "tap")
		expect(callbackFn).toHaveBeenCalledTimes(1)
	end)

	test("should trigger keyDown event", function()
		local element = Instance.new("Frame")
		element.Size = UDim2.new(0, 100, 0, 100)

		local callbackFn = jest.fn()

		element.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
				callbackFn()
			end
		end)

		expect(callbackFn).toHaveBeenCalledTimes(0)
		dispatchEvent(element, "keyDown", { key = Enum.KeyCode.Escape })
		expect(callbackFn).toHaveBeenCalledTimes(1)
	end)

	test("should trigger keyUp event", function()
		local element = Instance.new("Frame")
		element.Size = UDim2.new(0, 100, 0, 100)

		local callbackFn = jest.fn()

		element.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
				callbackFn()
			end
		end)

		expect(callbackFn).toHaveBeenCalledTimes(0)
		dispatchEvent(element, "keyUp", { key = Enum.KeyCode.Escape })
		expect(callbackFn).toHaveBeenCalledTimes(1)
	end)

	test("should trigger change event", function()
		local element = Instance.new("TextBox")
		element.Size = UDim2.new(0, 100, 0, 100)
		element.Text = ""

		local callbackFn = jest.fn()

		element.Changed:Connect(function(property: string)
			if property == "Text" then
				callbackFn()
			end
		end)

		expect(callbackFn).toHaveBeenCalledTimes(0)
		dispatchEvent(element, "change", { target = { Text = "Hello" } })
		expect(callbackFn).toHaveBeenCalledTimes(1)
	end)

	test("should trigger resize event", function()
		local element = Instance.new("Frame")
		element.Size = UDim2.new(0, 100, 0, 100)

		local callbackFn = jest.fn()

		element.Changed:Connect(function(property: string)
			if property == "Size" then
				callbackFn()
			end
		end)

		expect(callbackFn).toHaveBeenCalledTimes(0)
		dispatchEvent(element, "resize", { value = UDim2.new(0, 200, 0, 200) })
		expect(callbackFn).toHaveBeenCalledTimes(1)
	end)

	describe("input validation", function()
		test("should throw when click validation fails", function()
			local container = Instance.new("Frame")
			container.Size = UDim2.fromScale(0, 0)
			container.ClipsDescendants = true

			local button = Instance.new("TextButton")
			button.Size = UDim2.new(0, 100, 0, 100)
			button.Parent = container

			local spy, callbackFn = jest.fn()
			button.Activated:Connect(callbackFn)

			-- Does not throw with validation disabled...
			expect(function()
				dispatchEvent(button, "clickWithoutValidation")
			end).never.toThrow()

			-- ...but the click doesn't work either
			expect(spy).toHaveBeenCalledTimes(0)

			expect(function()
				dispatchEvent(button, "click")
			end).toThrow("TextButton is outside bounds of ancestor Frame")
		end)

		test("should throw when tap validation fails", function()
			local container = Instance.new("Frame")
			container.Size = UDim2.fromScale(0, 0)
			container.ClipsDescendants = true

			local button = Instance.new("TextButton")
			button.Size = UDim2.new(0, 100, 0, 100)
			button.Parent = container

			local spy, callbackFn = jest.fn()
			button.Activated:Connect(callbackFn)

			-- Does not throw with validation disabled...
			expect(function()
				dispatchEvent(button, "tapWithoutValidation")
			end).never.toThrow()

			-- ...but the click doesn't work either
			expect(spy).toHaveBeenCalledTimes(0)

			expect(function()
				dispatchEvent(button, "tap")
			end).toThrow("TextButton is outside bounds of ancestor Frame")
		end)
	end)
end)
