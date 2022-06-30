-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/src/__tests__/wait-for.js
return function()
	local Packages = script.Parent.Parent.Parent
	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Error = LuauPolyfill.Error
	local setTimeout = LuauPolyfill.setTimeout

	local Promise = require(Packages.Promise)

	local JestGlobals = require(Packages.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect
	local jest = JestGlobals.jest

	-- ROBLOX deviation START: not exactly __dirname, but enough to match
	local __dirname = "wait%-for%.spec"
	-- ROBLOX deviation END

	local waitFor = require(script.Parent.Parent["wait-for"]).waitFor
	local configModule = require(script.Parent.Parent.config)
	local configure = configModule.configure
	local getConfig = configModule.getConfig
	local renderIntoDocument = require(script.Parent.helpers["test-utils"])(afterEach).renderIntoDocument

	local function deferred()
		local resolve, reject
		local promise = Promise.new(function(res, rej)
			resolve = res
			reject = rej
		end)
		return { promise = promise, resolve = resolve, reject = reject }
	end

	local originalConfig
	beforeEach(function()
		originalConfig = getConfig()
	end)

	afterEach(function()
		configure(originalConfig)
		-- restore timers
		jest.useRealTimers()
	end)

	it("waits callback to not throw an error", function()
		return Promise.resolve()
			:andThen(function()
				local spy = jest.fn()
				-- we are using random timeout here to simulate a real-time example
				-- of an async operation calling a callback at a non-deterministic time
				local randomTimeout = math.floor(math.random() * 60)
				setTimeout(spy, randomTimeout)

				waitFor(function()
					return jestExpect(spy).toHaveBeenCalledTimes(1)
				end):expect()
				jestExpect(spy).toHaveBeenCalledWith()
			end)
			:expect()
	end)

	-- we used to have a limitation where we had to set an interval of 0 to 1
	-- otherwise there would be problems. I don't think this limitation exists
	-- anymore, but we'll keep this test around to make sure a problem doesn't
	-- crop up.
	it("can accept an interval of 0", function()
		return waitFor(function() end, { interval = 0 }):expect()
	end)

	it("can timeout after the given timeout time", function()
		return Promise.resolve()
			:andThen(function()
				local error_ = Error.new("throws every time")
				local result = waitFor(function()
					error(error_)
				end, { timeout = 8, interval = 5 })
					:catch(function(e)
						return e
					end)
					:expect()
				jestExpect(result).toBe(error_)
			end)
			:expect()
	end)

	it("if no error is thrown then throws a timeout error", function()
		return Promise.resolve()
			:andThen(function()
				local result = waitFor(function()
					-- eslint-disable-next-line no-throw-literal
					error(nil)
				end, {
					timeout = 8,
					interval = 5,
					onTimeout = function(e)
						return e
					end,
				})
					:catch(function(e)
						return e
					end)
					:expect()
				-- ROBLOX deviation START: replaced toMatchInlineSnapshot
				jestExpect(result.message).toMatch("Timed out in waitFor.")
				-- ROBLOX deviation END
			end)
			:expect()
	end)
	it("if showOriginalStackTrace on a timeout error then the stack trace does not include this file", function()
		return Promise.resolve()
			:andThen(function()
				local result = waitFor(function()
					-- eslint-disable-next-line no-throw-literal
					error(nil)
				end, { timeout = 8, interval = 5, showOriginalStackTrace = true })
					:catch(function(e)
						return e
					end)
					:expect()
				jestExpect(result.stack).never.toMatch(__dirname)
			end)
			:expect()
	end)

	it("uses full stack error trace when showOriginalStackTrace present", function()
		return Promise.resolve()
			:andThen(function()
				local error_ = Error.new("Throws the full stack trace")
				-- even if the error is a TestingLibraryElementError
				error_.name = "TestingLibraryElementError"
				local originalStackTrace = error_.stack
				local result = waitFor(function()
					error(error_)
				end, { timeout = 8, interval = 5, showOriginalStackTrace = true })
					:catch(function(e)
						return e
					end)
					:expect()
				jestExpect(result.stack).toBe(originalStackTrace)
				return result
			end)
			:expect()
	end)

	it("does not change the stack trace if the thrown error is not a TestingLibraryElementError", function()
		return Promise.resolve()
			:andThen(function()
				local error_ = Error.new("Throws the full stack trace")
				local originalStackTrace = error_.stack
				local result = waitFor(function()
					error(error_)
				end, { timeout = 8, interval = 5 })
					:catch(function(e)
						return e
					end)
					:expect()
				jestExpect(result.stack).toBe(originalStackTrace)
			end)
			:expect()
	end)

	it("provides an improved stack trace if the thrown error is a TestingLibraryElementError", function()
		return Promise.resolve()
			:andThen(function()
				local error_ = Error.new("Throws the full stack trace")
				error_.name = "TestingLibraryElementError"
				local originalStackTrace = error_.stack
				local result = waitFor(function()
					error(error_)
				end, { timeout = 8, interval = 5 })
					:catch(function(e)
						return e
					end)
					:expect()
				-- too hard to test that the stack trace is what we want it to be
				-- so we'll just make sure that it's not the same as the original
				jestExpect(result.stack).never.toBe(originalStackTrace)
			end)
			:expect()
	end)

	it("throws nice error if provided callback is not a function", function()
		-- ROBLOX TODO use queries when available
		-- ROBLOX deviation START: replace with Instance
		-- 		local queryByTestId = renderIntoDocument([[

		--     <div data-testid="div"></div>
		--   ]]).queryByTestId
		-- 		local someElement = queryByTestId("div")
		local someElement = Instance.new("Frame")
		-- ROBLOX deviation END
		jestExpect(function()
			return waitFor(someElement)
		end).toThrow("Received `callback` arg must be a function")
	end)

	-- ROBLOX FIXME: needs prettyDOM, result will be different
	itFIXME("timeout logs a pretty DOM", function()
		return Promise.resolve()
			:andThen(function()
				-- ROBLOX deviation START: replace with Instance
				-- renderIntoDocument('<div id="pretty">how pretty</div>')
				local div = Instance.new("Frame")
				renderIntoDocument({ div })
				-- ROBLOX deviation END
				local error_ = waitFor(function()
					error(Error.new("always throws"))
				end, { timeout = 1 })
					:catch(function(e)
						return e
					end)
					:expect()
				jestExpect(error_.message).toBe([[
always throws

Ignored nodes: comments, <script />, <style />
<html>
  <head />
  <body>
    <div
      id="pretty"
    >
      how pretty
    </div>
  </body>
</html>
]])
			end)
			:expect()
	end)

	it("should delegate to config.getElementError", function()
		return Promise.resolve()
			:andThen(function()
				local elementError = Error.new("Custom element error")
				local getElementError = jest.fn().mockImplementation(function()
					return elementError
				end)
				configure({ getElementError = getElementError })
				local div = Instance.new("Frame")
				div.Name = "pretty"
				-- renderIntoDocument('<div id="pretty">how pretty</div>')
				renderIntoDocument({ div })
				local error_ = waitFor(function()
					error(Error.new("always throws"))
				end, { timeout = 1 })
					:catch(function(e)
						return e
					end)
					:expect()
				jestExpect(getElementError).toBeCalledTimes(1)
				-- ROBLOX deviation START: use toBe instead of toMatchInlineSnapshot
				jestExpect(error_.message).toBe("Custom element error")
				-- ROBLOX deviation END
			end)
			:expect()
	end)

	it("when a promise is returned, it does not call the callback again until that promise rejects", function()
		return Promise.resolve()
			:andThen(function()
				local function sleep(t)
					return Promise.new(function(r)
						return setTimeout(r, t)
					end)
				end
				local p1 = deferred()
				local waitForCb = jest.fn(function()
					return p1.promise
				end)
				local waitForPromise = waitFor(waitForCb, { interval = 1 })
				jestExpect(waitForCb).toHaveBeenCalledTimes(1)
				waitForCb:mockClear()
				sleep(50):expect()
				jestExpect(waitForCb).toHaveBeenCalledTimes(0)
				local p2 = deferred()
				waitForCb.mockImplementation(function()
					return p2.promise
				end)
				p1:reject("p1 rejection (should not fail this test)")
				sleep(50):expect()
				jestExpect(waitForCb).toHaveBeenCalledTimes(1)
				p2:resolve()
				waitForPromise:expect()
			end)
			:expect()
	end)

	-- ROBLOX FIXME: needs prettyDOM, result will be different
	itFIXME(
		"when a promise is returned, if that is not resolved within the timeout, then waitFor is rejected",
		function()
			return Promise.resolve()
				:andThen(function()
					local function sleep(t)
						return Promise.new(function(r)
							return setTimeout(r, t)
						end)
					end
					local promise = deferred().promise
					local waitForError = waitFor(function()
						return promise
					end, { timeout = 1 }):catch(function(e)
						return e
					end)
					sleep(5):expect()
					-- ROBLOX deviation START: use toBe instead of toMatchInlineSnapshot
					jestExpect(waitForError:expect().message).toBe([[
Timed out in waitFor.

Ignored nodes: comments, <script />, <style />
<html>
  <head />
  <body />
</html>
]])
					-- ROBLOX deviation END
				end)
				:expect()
		end
	)

	it("if you switch from fake timers to real timers during the wait period you get an error", function()
		return Promise.resolve()
			:andThen(function()
				jest.useFakeTimers()
				local waitForError = waitFor(function()
					error(Error.new("this error message does not matter..."))
				end):catch(function(e)
					return e
				end)
				-- this is the problem...
				jest.useRealTimers()
				local error_ = waitForError:expect()
				-- ROBLOX deviation START: toMatchInlineSnapshot not available
				jestExpect(error_.message).toBe(
					"Changed from using fake timers to real timers while using waitFor. This is not allowed and will result in very strange behavior. Please ensure you're awaiting all async things your test is doing before changing to real timers. For more info, please go to https://github.com/testing-library/dom-testing-library/issues/830"
				)
				-- ROBLOX deviation END
				-- stack trace has this file in it
				jestExpect(error_.stack).toMatch(__dirname)
			end)
			:expect()
	end)

	it("if you switch from real timers to fake timers during the wait period you get an error", function()
		return Promise.resolve()
			:andThen(function()
				local waitForError = waitFor(function()
					error(Error.new("this error message does not matter..."))
				end):catch(function(e)
					return e
				end)
				-- this is the problem...
				jest.useFakeTimers()
				local error_ = waitForError:expect()
				jestExpect(error_.message).toBe(
					"Changed from using real timers to fake timers while using waitFor. This is not allowed and will result in very strange behavior. Please ensure you're awaiting all async things your test is doing before changing to fake timers. For more info, please go to https://github.com/testing-library/dom-testing-library/issues/830"
				)
				-- stack trace has this file in it
				jestExpect(error_.stack).toMatch(__dirname)
			end)
			:expect()
	end)

	it("the fake timers => real timers error shows the original stack trace when configured to do so", function()
		return Promise.resolve()
			:andThen(function()
				jest.useFakeTimers()
				local waitForError = waitFor(function()
					error(Error.new("this error message does not matter..."))
				end, { showOriginalStackTrace = true }):catch(function(e)
					return e
				end)
				jest.useRealTimers()
				jestExpect(waitForError:expect().stack).never.toMatch(__dirname)
			end)
			:expect()
	end)

	it("the real timers => fake timers error shows the original stack trace when configured to do so", function()
		return Promise.resolve()
			:andThen(function()
				local waitForError = waitFor(function()
					error(Error.new("this error message does not matter..."))
				end, { showOriginalStackTrace = true }):catch(function(e)
					return e
				end)
				jest.useFakeTimers()
				jestExpect(waitForError:expect().stack).never.toMatch(__dirname)
			end)
			:expect()
	end)

	-- unstable_advanceTimersWrapper returning thenable (other than Promise) not supported
	itFIXME("does not work after it resolves", function()
		return Promise.resolve()
			:andThen(function()
				-- ROBLOX deviation START: no selection of modern/legacy timers
				jest.useFakeTimers()
				-- ROBLOX deviation END
				local context = "initial"
				configure({
					unstable_advanceTimersWrapper = function(callback)
						local originalContext = context
						context = "act"
						local ok, result = pcall(function(): any
							local result = callback()
							-- eslint-disable-next-line jest/no-if
							if typeof(if typeof(result) == "table" then result.andThen else nil) == "function" then
								local thenable = result
								return {
									andThen = function(self, resolve, reject)
										thenable:andThen(function(returnValue)
											context = originalContext
											resolve(returnValue)
										end, function(error_)
											context = originalContext
											reject(error_)
										end)
									end,
								}
							else
								context = originalContext
								return nil
							end
						end)
						if not ok then
							context = originalContext
							return nil
						end
						return result
					end,
					asyncWrapper = function(callback)
						return Promise.resolve():andThen(function()
							local originalContext = context
							context = "no-act"
							local ok, result = pcall(function()
								callback():expect()
							end)
							context = originalContext

							if not ok then
								error(result)
							end
						end)
					end,
				})

				local data = nil
				setTimeout(function()
					data = "resolved"
				end, 100)

				waitFor(function()
					if data == nil then
						error(Error.new("not found"))
					end
				end, { interval = 50 }):expect()

				jestExpect(context).toEqual("initial")

				Promise:resolve():expect()

				jestExpect(context).toEqual("initial")
			end)
			:expect()
	end)
end