-- ROBLOX upstream: No upstream
--!strict
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Packages = script.Parent.Parent.Parent.Parent

local JestGlobals = require(Packages.JestGlobals)
local expect = JestGlobals.expect
local test = JestGlobals.test
local describe = JestGlobals.describe
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach

local InputValidation = require(script.Parent.Parent["InputValidation.roblox"])
local assertMounted = InputValidation.assertMounted
local assertCanActivate = InputValidation.assertCanActivate
local assertVisibleWithinAncestors = InputValidation.assertVisibleWithinAncestors
local assertFirstInputTarget = InputValidation.assertFirstInputTarget
local validateInput = InputValidation.validateInput
local getCenter = InputValidation.getCenter

local dispatchEvent = require(script.Parent.Parent.dispatchEvent)

describe("input validation", function()
	local MountedRoot
	beforeEach(function()
		MountedRoot = Instance.new("Folder")
		MountedRoot.Name = "Test"
		MountedRoot.Parent = CoreGui
	end)

	afterEach(function()
		MountedRoot:Destroy()
	end)

	local function mountInContainer(child: Instance, containerClass: string?)
		local container = Instance.new(containerClass or "ScreenGui") :: GuiBase2d
		container.Parent = MountedRoot

		child.Parent = container
		return container
	end

	local function newButton(name, size, zIndex: number?)
		local button = Instance.new("TextButton")
		button.Name = name
		button.ZIndex = zIndex or 1
		button.Size = size
		return button
	end

	local function validateClick(element: GuiObject)
		return function()
			-- Throws if click does not succeed
			validateInput(element, function()
				local center = getCenter(element)

				VirtualInputManager:SendMouseButtonEvent(center.X, center.Y, 0, true, nil :: any, 1)
				VirtualInputManager:SendMouseButtonEvent(center.X, center.Y, 0, false, nil :: any, 1)
				VirtualInputManager:WaitForInputEventsProcessed()
			end)
		end
	end

	describe("assertMounted", function()
		local function assertOnArg(element)
			return function()
				assertMounted(element)
			end
		end

		test("throws on non-GuiObject", function()
			local part = Instance.new("Part")
			expect(assertOnArg(part)).toThrow("(Part) is not a GuiObject")

			local screenGui = Instance.new("ScreenGui")
			expect(assertOnArg(screenGui)).toThrow("(ScreenGui) is not a GuiObject")
		end)

		test("throws on unmounted element", function()
			local textButton = Instance.new("TextButton")
			expect(assertOnArg(textButton)).toThrow("(TextButton) is not mounted into the DataModel")

			-- Parent it to a ScreenGui but not the DataModel
			local screenGui = Instance.new("ScreenGui")
			local buttonInUnmountedGui = Instance.new("ImageButton")
			buttonInUnmountedGui.Parent = screenGui

			expect(assertOnArg(buttonInUnmountedGui)).toThrow("(ImageButton) is not mounted into the DataModel")
		end)

		test("succeeds with a valid Element", function()
			local screenGui = Instance.new("ScreenGui")
			screenGui.Parent = MountedRoot
			local button = Instance.new("ImageButton")
			button.Parent = screenGui

			expect(assertOnArg(button)).never.toThrow()
		end)
	end)

	describe("assertCanActivate", function()
		local function assertOnArg(element)
			return function()
				assertCanActivate(element)
			end
		end

		test("throws if target is not a GuiButton or TextBox", function()
			local button = newButton("Button", UDim2.fromOffset(100, 100))
			local frame = mountInContainer(button, "Frame") :: Frame
			frame.Name = "Target"
			frame.Size = UDim2.fromOffset(100, 100)

			mountInContainer(frame)

			expect(assertOnArg(frame)).toThrow(
				"CoreGui.Test.ScreenGui.Target (Frame) was not clickable for the following reason(s):\n"
					.. "* target is not a GuiButton or TextBox, so it will not sink inputs unless `Active` is true."
			)
			expect(validateClick(frame)).toThrow()
		end)

		test("throws with suggestions for better targets if target is not a GuiButton or TextBox", function()
			local button = newButton("Button", UDim2.fromOffset(100, 100))

			local frame = mountInContainer(button, "Frame") :: Frame
			frame.Name = "Target"
			frame.Size = UDim2.fromOffset(100, 100)

			-- Add another potential target
			local textBox = Instance.new("TextBox")
			textBox.Name = "TextBox"
			textBox.Parent = frame

			mountInContainer(frame)

			expect(assertOnArg(frame)).toThrow(
				"\tThe target instance has the following descendants that may be better click targets:"
					.. "\n\t\t* Target.Button (TextButton)"
					.. "\n\t\t* Target.TextBox (TextBox)"
			)
			expect(validateClick(frame)).toThrow()
		end)

		test("throws if target is not a descendant of a LayerCollector", function()
			local target = newButton("Target", UDim2.fromOffset(100, 100))
			target.Parent = MountedRoot

			expect(assertOnArg(target)).toThrow("not a descendant of a LayerCollector")
			expect(validateClick(target)).toThrow()

			mountInContainer(target)
			expect(assertOnArg(target)).never.toThrow()
			expect(validateClick(target)).never.toThrow()
		end)

		test("throws if target is not Active", function()
			local target = newButton("Target", UDim2.fromOffset(100, 100))
			target.Active = false
			mountInContainer(target)

			expect(assertOnArg(target)).toThrow("Active")
			expect(validateClick(target)).toThrow()
		end)

		test("throws if target is not Visible", function()
			local target = newButton("Target", UDim2.fromOffset(100, 100))
			target.Visible = false
			mountInContainer(target)

			expect(assertOnArg(target)).toThrow("Visible")
			expect(validateClick(target)).toThrow()
		end)

		test("throws with multiple reasons", function()
			local target = newButton("Target", UDim2.fromOffset(100, 100))
			target.Active = false
			target.Visible = false
			mountInContainer(target)

			expect(assertOnArg(target)).toThrow("* target is not Active\n* target is not Visible")
			expect(validateClick(target)).toThrow()
		end)

		test("succeeds for a simple mounted button", function()
			local target = newButton("Target", UDim2.fromOffset(100, 100))

			mountInContainer(target)

			expect(assertOnArg(target)).never.toThrow()
			expect(validateClick(target)).never.toThrow()
		end)
	end)

	describe("assertVisibleWithinAncestors", function()
		local function assertOnArgs(element)
			return function()
				assertVisibleWithinAncestors(element)
			end
		end

		(describe :: any).each({
			{ "left", UDim2.new(0, -20, 0, 0) } :: { any },
			{ "right", UDim2.new(1, 0, 0, 0) } :: { any },
			{ "top", UDim2.new(0, 0, 0, -20) } :: { any },
			{ "bottom", UDim2.new(0, 0, 1, 0) } :: { any },
		})("check viewport on all sides", function(edge: string, position)
			test("throws when target is beyond " .. edge .. " edge of ScreenGui viewport", function()
				local container = Instance.new("ScreenGui")
				container.Parent = MountedRoot

				local button = Instance.new("TextButton")
				button.Parent = container
				button.Size = UDim2.fromOffset(20, 20)
				button.Position = position

				expect(assertOnArgs(button)).toThrow(
					"TextButton is outside bounds of ancestor ScreenGui (" .. edge .. ")"
				)
				expect(validateClick(button)).toThrow()
			end)

			test("throws when target is beyond " .. edge .. " edge of SurfaceGui viewport", function()
				local container = Instance.new("SurfaceGui")
				container.Parent = MountedRoot

				local button = Instance.new("TextButton")
				button.Parent = container
				button.Size = UDim2.fromOffset(20, 20)
				button.Position = position

				expect(assertOnArgs(button)).toThrow(
					"TextButton is outside bounds of ancestor SurfaceGui (" .. edge .. ")"
				)
				expect(validateClick(button)).toThrow()
			end)

			test("throws when target is beyond " .. edge .. " edge of Frame viewport", function()
				local container = Instance.new("Frame")
				container.Parent = MountedRoot
				container.Size = UDim2.fromOffset(100, 100)
				container.ClipsDescendants = true

				local button = Instance.new("TextButton")
				button.Parent = container
				button.Size = UDim2.fromOffset(20, 20)
				button.Position = position

				expect(assertOnArgs(button)).toThrow("TextButton is outside bounds of ancestor Frame (" .. edge .. ")")
				expect(validateClick(button)).toThrow()
			end)

			test("throws when target is beyond " .. edge .. " edge of ScrollingFrame visible area", function()
				local container = Instance.new("ScrollingFrame")
				container.Parent = MountedRoot
				container.Size = UDim2.fromOffset(100, 100)
				container.CanvasSize = UDim2.fromOffset(200, 200)
				container.CanvasPosition = Vector2.new(50, 50)

				local button = Instance.new("TextButton")
				button.Parent = container
				button.Size = UDim2.fromOffset(20, 20)

				-- adjust position to be relative to canvas position, so it's within
				-- the canvas but still outside the viewport of the ScrollingFrame
				button.Position = position + UDim2.fromOffset(50, 50)

				expect(assertOnArgs(button)).toThrow(
					"TextButton is outside bounds of ancestor ScrollingFrame (" .. edge .. ")"
				)
				expect(validateClick(button)).toThrow()
			end)
		end);

		(describe :: any).each({
			{ "top-left", UDim2.new(0, -20, 0, -20) } :: { any },
			{ "top-right", UDim2.new(1, 0, 0, -20) } :: { any },
			{ "bottom-left", UDim2.new(0, -20, 1, 0) } :: { any },
			{ "bottom-right", UDim2.new(1, 0, 1, 0) } :: { any },
		})("check outside viewport corners", function(edge: string, position)
			test("throws when target is beyond " .. edge .. " corner viewport", function()
				local container = Instance.new("ScreenGui")
				container.Parent = MountedRoot

				local button = Instance.new("TextButton")
				button.Parent = container
				button.Size = UDim2.fromOffset(20, 20)
				button.Position = position

				expect(assertOnArgs(button)).toThrow(edge)
				expect(validateClick(button)).toThrow()
			end)
		end)

		test("includes target, container, and boundary info in the error", function()
			local container = Instance.new("Frame")
			container.Parent = MountedRoot
			container.Size = UDim2.fromOffset(300, 300)
			container.ClipsDescendants = true

			local button = Instance.new("TextButton")
			button.Parent = container
			button.Size = UDim2.fromOffset(30, 15)
			button.Position = UDim2.fromOffset(245, 295)

			expect(assertOnArgs(button)).toThrow(
				"TextButton is outside bounds of ancestor Frame (bottom)\n\n"
					.. "click at: (260, 302.5)\n"
					.. "target:   CoreGui.Test.Frame.TextButton (TextButton)\n"
					.. "\telement bounds: (245, 295) (275, 310)\n"
					.. "ancestor: CoreGui.Test.Frame (Frame)\n"
					.. "\telement bounds: (0, 0) (300, 300)"
			)
		end)

		test("succeeds when target is fully within viewport", function()
			local container = Instance.new("ScreenGui")
			container.Parent = MountedRoot

			local button = Instance.new("TextButton")
			button.Parent = container
			button.Size = UDim2.fromOffset(20, 20)
			button.Position = UDim2.fromOffset(0, 0)

			expect(assertOnArgs(button)).never.toThrow()
			expect(validateClick(button)).never.toThrow()
		end)

		test("succeeds when target's center point is within viewport", function()
			local container = Instance.new("ScreenGui")
			container.Parent = MountedRoot

			local button = Instance.new("TextButton")
			button.Parent = container
			button.Size = UDim2.fromOffset(20, 20)
			-- center point is still in view
			button.Position = UDim2.fromOffset(-8, -8)

			expect(assertOnArgs(button)).never.toThrow()
			expect(validateClick(button)).never.toThrow()
		end)

		test("succeeds when outside of a parent that isn't clipping it", function()
			local container = Instance.new("ScreenGui")
			container.Parent = MountedRoot

			local frame = Instance.new("Frame")
			frame.Parent = container
			frame.Size = UDim2.fromOffset(100, 100)
			frame.ClipsDescendants = false

			local button = Instance.new("TextButton")
			button.Parent = container
			button.Size = UDim2.fromOffset(20, 20)
			button.Position = UDim2.fromOffset(150, 150)

			expect(assertOnArgs(button)).never.toThrow()
			expect(validateClick(button)).never.toThrow()
		end)

		test("throws when outside parent", function()
			local button = newButton("Target", UDim2.fromOffset(100, 100))
			button.Position = UDim2.fromOffset(100, 0)

			local frame = mountInContainer(button, "Frame") :: Frame
			frame.Size = UDim2.fromOffset(100, 100)
			frame.ClipsDescendants = true

			mountInContainer(frame)

			expect(assertOnArgs(button)).toThrow("Target is outside bounds of ancestor Frame (right)")
			expect(validateClick(button)).toThrow()
		end)

		test("throws when outside grandparent", function()
			local button = newButton("Target", UDim2.fromOffset(50, 50))
			button.Position = UDim2.fromOffset(0, 0)

			-- Within parent Frame
			local innerFrame = mountInContainer(button, "Frame") :: Frame
			innerFrame.Name = "Parent"
			innerFrame.Size = UDim2.fromOffset(100, 100)
			innerFrame.Position = UDim2.fromOffset(100, 0)
			innerFrame.ClipsDescendants = true

			-- Clipped by grandparent Frame
			local outerFrame = mountInContainer(innerFrame, "Frame") :: Frame
			outerFrame.Name = "Grandparent"
			outerFrame.Size = UDim2.fromOffset(100, 100)
			outerFrame.ClipsDescendants = true

			mountInContainer(outerFrame)

			expect(assertOnArgs(button)).toThrow("Target is outside bounds of ancestor Grandparent (right)")
			expect(validateClick(button)).toThrow()
		end)

		test("throws when whole subtree is outside LayerCollector", function()
			local button = newButton("Target", UDim2.fromOffset(100, 100))
			button.Position = UDim2.fromOffset(0, 0)

			local frame = mountInContainer(button, "Frame") :: Frame
			frame.Size = UDim2.fromOffset(100, 100)
			frame.Position = UDim2.fromOffset(-200, 0)

			mountInContainer(frame)

			expect(assertOnArgs(button)).toThrow("Target is outside bounds of ancestor ScreenGui (left)")
			expect(validateClick(button)).toThrow()
		end)

		test("succeeds when child is in view of all ancestors", function()
			local button = newButton("Target", UDim2.fromOffset(50, 50))
			button.Position = UDim2.fromOffset(0, 0)

			-- Within parent Frame
			local innerFrame = mountInContainer(button, "Frame") :: Frame
			innerFrame.Name = "Parent"
			innerFrame.Size = UDim2.fromOffset(100, 100)
			innerFrame.ClipsDescendants = true

			-- Within grandparent Frame
			local outerFrame = mountInContainer(innerFrame, "Frame") :: Frame
			outerFrame.Name = "Grandparent"
			outerFrame.Size = UDim2.fromOffset(100, 100)
			outerFrame.ClipsDescendants = true

			mountInContainer(outerFrame)

			expect(assertOnArgs(button)).never.toThrow()
			expect(validateClick(button)).never.toThrow()
		end)
	end)

	describe("assertFirstInputTarget", function()
		local function assertOnArg(element)
			return function()
				assertFirstInputTarget(element)
			end
		end

		test("throws when target is obscured by sibling", function()
			local target = newButton("Target", UDim2.fromOffset(300, 300), 1)
			local obscurer = newButton("Obscurer", UDim2.fromOffset(300, 300), 2)

			local container = Instance.new("Frame")
			container.Name = "Container"
			container.Size = UDim2.fromOffset(300, 300)

			local screenGui = mountInContainer(container) :: ScreenGui
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			obscurer.Parent = container
			target.Parent = container

			expect(assertOnArg(target)).toThrow(
				"element is obscured by another clickable GuiObject at the target click location\n\n"
					.. " click at: (150, 150)\n"
					.. "   target: CoreGui.Test.ScreenGui.Container.Target (TextButton)\n"
					.. "\telement bounds: (0, 0) (300, 300)\n"
					.. "obscuring: CoreGui.Test.ScreenGui.Container.Obscurer (TextButton)\n"
					.. "\telement bounds: (0, 0) (300, 300)"
			)
			expect(validateClick(target)).toThrow()
		end)

		test("throws even when target is obscured by a non-Active sibling", function()
			local target = newButton("Target", UDim2.fromOffset(300, 300), 1)
			local obscurer = newButton("Obscurer", UDim2.fromOffset(300, 300), 2)
			obscurer.Active = false

			local container = Instance.new("Frame")
			container.Name = "Container"
			container.Size = UDim2.fromOffset(300, 300)

			local screenGui = mountInContainer(container) :: ScreenGui
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			obscurer.Parent = container
			target.Parent = container

			expect(assertOnArg(target)).toThrow(
				"element is obscured by another clickable GuiObject at the target click location\n\n"
					.. " click at: (150, 150)\n"
					.. "   target: CoreGui.Test.ScreenGui.Container.Target (TextButton)\n"
					.. "\telement bounds: (0, 0) (300, 300)\n"
					.. "obscuring: CoreGui.Test.ScreenGui.Container.Obscurer (TextButton)\n"
					.. "\telement bounds: (0, 0) (300, 300)"
			)
			expect(validateClick(target)).toThrow()
		end)

		test("throws when target is obscured by parent via global Z-order overrides", function()
			local target = newButton("Target", UDim2.fromOffset(300, 300), 1)
			local obscuringParent = newButton("Obscurer", UDim2.fromOffset(300, 300), 2)

			local screenGui = mountInContainer(obscuringParent) :: ScreenGui
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
			target.Parent = obscuringParent

			expect(assertOnArg(target)).toThrow(
				"element is obscured by another clickable GuiObject at the target click location\n\n"
					.. " click at: (150, 150)\n"
					.. "   target: CoreGui.Test.ScreenGui.Obscurer.Target (TextButton)\n"
					.. "\telement bounds: (0, 0) (300, 300)\n"
					.. "obscuring: CoreGui.Test.ScreenGui.Obscurer (TextButton)\n"
					.. "\telement bounds: (0, 0) (300, 300)"
			)
			expect(validateClick(target)).toThrow()
		end)

		test("succeeds when the target is the first clickable GuiObject", function()
			local target = newButton("Target", UDim2.fromOffset(300, 300), 3)
			local siblingA = newButton("SiblingA", UDim2.fromOffset(300, 300), 2)
			local siblingB = newButton("SiblingB", UDim2.fromOffset(300, 300), 1)

			local container = Instance.new("Frame")
			container.Name = "Container"
			container.Size = UDim2.fromOffset(300, 300)

			local screenGui = mountInContainer(container) :: ScreenGui
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			siblingA.Parent = container
			siblingB.Parent = container
			target.Parent = container

			expect(assertOnArg(target)).never.toThrow()
			expect(validateClick(target)).never.toThrow()
		end)

		test("succeeds when an obscurer is a non-clickable instance", function()
			local target = newButton("Target", UDim2.fromOffset(300, 300), 1)
			local obscurer = Instance.new("ImageLabel")
			obscurer.Name = "Obscurer"
			obscurer.ZIndex = 2
			obscurer.Size = UDim2.fromOffset(300, 300)

			local container = Instance.new("Frame")
			container.Name = "Container"
			container.Size = UDim2.fromOffset(300, 300)

			local screenGui = mountInContainer(container) :: ScreenGui
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			obscurer.Parent = container
			target.Parent = container

			expect(assertOnArg(target)).never.toThrow()
			expect(validateClick(target)).never.toThrow()
		end)

		test("succeeds when an obscurer is scrolled out of its own view", function()
			local target = newButton("Target", UDim2.fromOffset(100, 100), 1)
			target.Position = UDim2.fromOffset(0, 100)

			local scrollingFrame = Instance.new("ScrollingFrame")
			scrollingFrame.Name = "ObscurerFrame"
			scrollingFrame.Size = UDim2.fromOffset(100, 100)
			scrollingFrame.CanvasSize = UDim2.fromOffset(100, 200)

			local obscurer = newButton("Obscurer", UDim2.fromOffset(100, 100), 2)
			obscurer.Position = UDim2.fromOffset(0, 100)
			obscurer.Parent = scrollingFrame

			local container = Instance.new("Frame")
			container.Name = "Container"
			container.Size = UDim2.fromOffset(100, 200)

			local screenGui = mountInContainer(container) :: ScreenGui
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			scrollingFrame.Parent = container
			target.Parent = container

			-- They occupy the same position...
			expect(target.AbsolutePosition).toEqual(obscurer.AbsolutePosition)
			-- ...but the obscurer is in scrolled out of view of its parent...
			expect(function()
				assertVisibleWithinAncestors(obscurer)
			end).toThrow()
			-- ...so our target should still be the first to receive clicks
			expect(assertOnArg(target)).never.toThrow()
			expect(validateClick(target)).never.toThrow()
		end)
	end)

	local function click(element)
		dispatchEvent(element, "click")
	end

	local function tap(element)
		dispatchEvent(element, "tap")
	end

	local interactionValidationCases: { { any } } = {
		{ "click", click },
		{ "tap", tap },
	};
	(describe :: any).each(interactionValidationCases)("interaction validation", function(name: string, interact)
		local function interactAndValidate(element)
			return function()
				interact(element)
			end
		end

		test(name .. " throws if scrolled out of view in a ScrollingFrame", function()
			local target = newButton("Target", UDim2.fromOffset(100, 100))

			local scrollingFrame = mountInContainer(target, "ScrollingFrame") :: ScrollingFrame
			scrollingFrame.Size = UDim2.fromOffset(100, 100)
			scrollingFrame.Position = UDim2.fromOffset(0, 100)
			scrollingFrame.CanvasSize = UDim2.fromOffset(100, 300)
			scrollingFrame.CanvasPosition = Vector2.new(0, 100)

			mountInContainer(scrollingFrame)

			expect(interactAndValidate(target)).toThrow("Target is outside bounds of ancestor ScrollingFrame (top)")
		end)

		test(name .. " throws if scrolled out of view in a nested ScrollingFrame", function()
			local target = newButton("Target", UDim2.fromOffset(100, 100))
			target.Position = UDim2.fromOffset(0, 100)

			local innerScrollingFrame = mountInContainer(target, "ScrollingFrame") :: ScrollingFrame
			innerScrollingFrame.Size = UDim2.fromOffset(100, 100)
			innerScrollingFrame.Position = UDim2.fromOffset(0, 100)
			innerScrollingFrame.CanvasSize = UDim2.fromOffset(100, 300)
			innerScrollingFrame.CanvasPosition = Vector2.new(0, 100)

			local outerScrollingFrame = mountInContainer(innerScrollingFrame, "ScrollingFrame") :: ScrollingFrame
			outerScrollingFrame.Size = UDim2.fromOffset(100, 300)
			outerScrollingFrame.Position = UDim2.fromOffset(100, 0)
			outerScrollingFrame.CanvasSize = UDim2.fromOffset(300, 300)
			outerScrollingFrame.CanvasPosition = Vector2.new(100, 0)

			mountInContainer(outerScrollingFrame)

			expect(interactAndValidate(target)).toThrow("Target is outside bounds of ancestor ScrollingFrame (left)")
		end)

		test(name .. " succeeds for a simple mounted button", function()
			local target = newButton("Target", UDim2.fromOffset(100, 100))

			mountInContainer(target)

			expect(interactAndValidate(target)).never.toThrow()
		end)

		test(name .. " succeeds for a slightly-offscreen button", function()
			local target = newButton("Target", UDim2.fromOffset(100, 100))
			target.Position = UDim2.fromOffset(-20, -20)

			mountInContainer(target)

			expect(interactAndValidate(target)).never.toThrow()
		end)

		test(name .. " succeeds for a visible button in a ScrollingFrame", function()
			local target = newButton("Target", UDim2.fromOffset(100, 100))
			target.Position = UDim2.fromOffset(0, 200)

			local scrollingFrame = mountInContainer(target, "ScrollingFrame") :: ScrollingFrame
			scrollingFrame.Size = UDim2.fromOffset(100, 100)
			scrollingFrame.CanvasSize = UDim2.fromOffset(100, 300)
			scrollingFrame.CanvasPosition = Vector2.new(0, 200)

			mountInContainer(scrollingFrame)

			expect(interactAndValidate(target)).never.toThrow()
		end)

		test(name .. " succeeds for a visible button in nested ScrollingFrames", function()
			local target = newButton("Target", UDim2.fromOffset(100, 100))
			target.Position = UDim2.fromOffset(0, 200)

			local innerScrollingFrame = mountInContainer(target, "ScrollingFrame") :: ScrollingFrame
			innerScrollingFrame.Size = UDim2.fromOffset(100, 100)
			innerScrollingFrame.Position = UDim2.fromOffset(200, 0)
			innerScrollingFrame.CanvasSize = UDim2.fromOffset(100, 300)
			innerScrollingFrame.CanvasPosition = Vector2.new(0, 200)

			local outerScrollingFrame = mountInContainer(innerScrollingFrame, "ScrollingFrame") :: ScrollingFrame
			outerScrollingFrame.Size = UDim2.fromOffset(100, 100)
			outerScrollingFrame.Position = UDim2.fromOffset(0, 0)
			outerScrollingFrame.CanvasSize = UDim2.fromOffset(300, 300)
			outerScrollingFrame.CanvasPosition = Vector2.new(200, 0)

			mountInContainer(outerScrollingFrame)
			expect(interactAndValidate(target)).never.toThrow()
		end)
	end)
end)
