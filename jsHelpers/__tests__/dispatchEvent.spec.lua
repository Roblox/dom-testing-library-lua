-- ROBLOX upstream: No upstream
return function()
	local Packages = script.Parent.Parent.Parent

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local jest = JestGlobals.jest

	local dispatchEvent = require(script.Parent.Parent.dispatchEvent)
	describe("dispatchEvent", function()
		it("should trigger click event", function()
			local element = Instance.new("TextButton")
			element.Size = UDim2.new(0, 100, 0, 100)
			element.Text = "Click Me"

			local callbackFn = jest.fn()

			element.Activated:Connect(function(...)
				callbackFn(...)
			end)

			jestExpect(callbackFn).toHaveBeenCalledTimes(0)
			dispatchEvent(element, "click")
			jestExpect(callbackFn).toHaveBeenCalledTimes(1)
		end)

		it("should trigger keyDown event", function()
			local element = Instance.new("Frame")
			element.Size = UDim2.new(0, 100, 0, 100)

			local callbackFn = jest.fn()

			element.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
					callbackFn()
				end
			end)

			jestExpect(callbackFn).toHaveBeenCalledTimes(0)
			dispatchEvent(element, "keyDown", { key = Enum.KeyCode.Escape })
			jestExpect(callbackFn).toHaveBeenCalledTimes(1)
		end)

		it("should trigger keyUp event", function()
			local element = Instance.new("Frame")
			element.Size = UDim2.new(0, 100, 0, 100)

			local callbackFn = jest.fn()

			element.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
					callbackFn()
				end
			end)

			jestExpect(callbackFn).toHaveBeenCalledTimes(0)
			dispatchEvent(element, "keyUp", { key = Enum.KeyCode.Escape })
			jestExpect(callbackFn).toHaveBeenCalledTimes(1)
		end)

		it("should trigger change event", function()
			local element = Instance.new("TextBox")
			element.Size = UDim2.new(0, 100, 0, 100)
			element.Text = ""

			local callbackFn = jest.fn()

			element.Changed:Connect(function(property: string)
				if property == "Text" then
					callbackFn()
				end
			end)

			jestExpect(callbackFn).toHaveBeenCalledTimes(0)
			dispatchEvent(element, "change", { target = { Text = "Hello" } })
			jestExpect(callbackFn).toHaveBeenCalledTimes(1)
		end)

		it("should trigger resize event", function()
			local element = Instance.new("Frame")
			element.Size = UDim2.new(0, 100, 0, 100)

			local callbackFn = jest.fn()

			element.Changed:Connect(function(property: string)
				if property == "Size" then
					callbackFn()
				end
			end)

			jestExpect(callbackFn).toHaveBeenCalledTimes(0)
			dispatchEvent(element, "resize", { value = UDim2.new(0, 200, 0, 200) })
			jestExpect(callbackFn).toHaveBeenCalledTimes(1)
		end)
	end)
end
