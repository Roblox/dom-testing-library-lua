-- ROBLOX upstream: https://github.com/babel/babel/blob/v7.18.5/packages/babel-code-frame/test/index.js
return function()
	local Packages = script.Parent.Parent.Parent.Parent

	local LuauPolyfill = require(Packages.LuauPolyfill)
	local Array = LuauPolyfill.Array

	local JestGlobals = require(Packages.JestGlobals)
	local jestExpect = JestGlobals.expect

	local HttpService = game:GetService("HttpService")

	local chalk = require(Packages.Chalk)
	local stripAnsi = require(script.Parent.Parent["strip-ansi"])
	local babelCodeFrame = require(script.Parent.Parent["babel-code-frame"])
	local _codeFrame = babelCodeFrame.default
	local codeFrameColumns = babelCodeFrame.codeFrameColumns
	-- ROBLOX deviation START: functions do not have props in Lua
	local codeFrame = _codeFrame
	-- ROBLOX deviation END

	describe("@babel/code-frame", function()
		it("basic usage", function()
			local rawLines = Array.join({ "class Foo {", "  constructor()", "};" }, "\n")
			jestExpect(codeFrame(rawLines, 2, 16)).toEqual(Array.join({
				"  1 | class Foo {",
				"> 2 |   constructor()",
				"    |                ^",
				"  3 | };",
			}, "\n"))
		end)
		it("optional column number", function()
			local rawLines = Array.join({ "class Foo {", "  constructor()", "};" }, "\n")
			jestExpect(codeFrame(rawLines, 2, nil)).toEqual(
				Array.join({ "  1 | class Foo {", "> 2 |   constructor()", "  3 | };" }, "\n")
			)
		end)
		it("maximum context lines and padding", function()
			local rawLines = Array.join({
				"/**",
				" * Sums two numbers.",
				" *",
				" * @param a Number",
				" * @param b Number",
				" * @returns Number",
				" */",
				"",
				"function sum(a, b) {",
				"  return a + b",
				"}",
			}, "\n")
			jestExpect(codeFrame(rawLines, 7, 2)).toEqual(Array.join({
				"   5 |  * @param b Number",
				"   6 |  * @returns Number",
				">  7 |  */",
				"     |  ^",
				"   8 |",
				"   9 | function sum(a, b) {",
				"  10 |   return a + b",
			}, "\n"))
		end)
		it("no unnecessary padding due to one-off errors", function()
			local rawLines = Array.join({
				"/**",
				" * Sums two numbers.",
				" *",
				" * @param a Number",
				" * @param b Number",
				" * @returns Number",
				" */",
				"",
				"function sum(a, b) {",
				"  return a + b",
				"}",
			}, "\n")
			jestExpect(codeFrame(rawLines, 6, 2)).toEqual(Array.join({
				"  4 |  * @param a Number",
				"  5 |  * @param b Number",
				"> 6 |  * @returns Number",
				"    |  ^",
				"  7 |  */",
				"  8 |",
				"  9 | function sum(a, b) {",
			}, "\n"))
		end)
		it("tabs", function()
			local rawLines = Array.join({ "\tclass Foo {", "\t  \t\t    constructor\t(\t)", "\t};" }, "\n")
			jestExpect(codeFrame(rawLines, 2, 25)).toEqual(Array.join({
				"  1 | \tclass Foo {",
				"> 2 | \t  \t\t    constructor\t(\t)",
				"    | \t  \t\t               \t \t ^",
				"  3 | \t};",
			}, "\n"))
		end)
		-- ROBLOX FIXME: highlightCode not available
		itSKIP("opts.highlightCode", function()
			local rawLines = "console.log('babel')"
			local result = codeFrame(rawLines, 1, 9, { highlightCode = true })
			local stripped = stripAnsi(result)
			jestExpect(#result).toBeGreaterThan(#stripped)
			jestExpect(stripped).toEqual(Array.join({ "> 1 | console.log('babel')", "    |         ^" }, "\n"))
		end)
		-- ROBLOX FIXME: highlightCode not available
		itSKIP("opts.highlightCode with multiple columns and lines", function()
			-- prettier-ignore
			local rawLines = Array.join({ "function a(b, c) {", "  return b + c;", "}" }, "\n")
			local result = codeFrameColumns(
				rawLines,
				{ start = { line = 1, column = 1 }, ["end"] = { line = 3, column = 1 } },
				{ highlightCode = true, message = "Message about things" }
			)
			local stripped = stripAnsi(result)
			jestExpect(stripped).toEqual(
				-- prettier-ignore
				Array.join({
					"> 1 | function a(b, c) {",
					"    | ^^^^^^^^^^^^^^^^^^",
					"> 2 |   return b + c;",
					"    | ^^^^^^^^^^^^^^^",
					"> 3 | }",
					"    | ^ Message about things",
				}, "\n")
			)
		end)
		it("opts.linesAbove", function()
			local rawLines = Array.join({
				"/**",
				" * Sums two numbers.",
				" *",
				" * @param a Number",
				" * @param b Number",
				" * @returns Number",
				" */",
				"",
				"function sum(a, b) {",
				"  return a + b",
				"}",
			}, "\n")
			jestExpect(codeFrame(rawLines, 7, 2, { linesAbove = 1 })).toEqual(Array.join({
				"   6 |  * @returns Number",
				">  7 |  */",
				"     |  ^",
				"   8 |",
				"   9 | function sum(a, b) {",
				"  10 |   return a + b",
			}, "\n"))
		end)
		it("opts.linesBelow", function()
			local rawLines = Array.join({
				"/**",
				" * Sums two numbers.",
				" *",
				" * @param a Number",
				" * @param b Number",
				" * @returns Number",
				" */",
				"",
				"function sum(a, b) {",
				"  return a + b",
				"}",
			}, "\n")
			jestExpect(codeFrame(rawLines, 7, 2, { linesBelow = 1 })).toEqual(Array.join({
				"  5 |  * @param b Number",
				"  6 |  * @returns Number",
				"> 7 |  */",
				"    |  ^",
				"  8 |",
			}, "\n"))
		end)
		it("opts.linesAbove and opts.linesBelow", function()
			local rawLines = Array.join({
				"/**",
				" * Sums two numbers.",
				" *",
				" * @param a Number",
				" * @param b Number",
				" * @returns Number",
				" */",
				"",
				"function sum(a, b) {",
				"  return a + b",
				"}",
			}, "\n")
			jestExpect(codeFrame(rawLines, 7, 2, { linesAbove = 1, linesBelow = 1 })).toEqual(
				Array.join({ "  6 |  * @returns Number", "> 7 |  */", "    |  ^", "  8 |" }, "\n")
			)
		end)
		it("opts.linesAbove no lines above", function()
			local rawLines = Array.join(
				{ "class Foo {", "  constructor() {", "    console.log(arguments);", "  }", "};" },
				"\n"
			)
			jestExpect(codeFrameColumns(rawLines, { start = { line = 2 } }, { linesAbove = 0 })).toEqual(Array.join({
				"> 2 |   constructor() {",
				"  3 |     console.log(arguments);",
				"  4 |   }",
				"  5 | };",
			}, "\n"))
		end)
		it("opts.linesBelow no lines below", function()
			local rawLines = Array.join(
				{ "class Foo {", "  constructor() {", "    console.log(arguments);", "  }", "};" },
				"\n"
			)
			jestExpect(codeFrameColumns(rawLines, { start = { line = 2 } }, { linesBelow = 0 })).toEqual(
				Array.join({ "  1 | class Foo {", "> 2 |   constructor() {" }, "\n")
			)
		end)
		it("opts.linesBelow single line", function()
			local rawLines = Array.join(
				{ "class Foo {", "  constructor() {", "    console.log(arguments);", "  }", "};" },
				"\n"
			)
			jestExpect(codeFrameColumns(rawLines, { start = { line = 2 } }, { linesAbove = 0, linesBelow = 0 })).toEqual(
				Array.join({ "> 2 |   constructor() {" }, "\n")
			)
		end)
		-- ROBLOX FIXME: forceColor not available
		itSKIP("opts.forceColor", function()
			local marker = chalk.red.bold
			local gutter = chalk.grey
			local rawLines = Array.join({ "", "", "", "" }, "\n")
			jestExpect(codeFrame(rawLines, 3, nil, { linesAbove = 1, linesBelow = 1, forceColor = true })).toEqual(
				chalk.reset(Array.join({
					" " .. gutter(" 2 |"),
					marker(">") .. gutter(" 3 |"),
					" " .. gutter(" 4 |"),
				}, "\n"))
			)
		end)
		-- ROBLOX FIXME: forceColor not available
		itSKIP("jsx", function()
			local gutter = chalk.grey
			local yellow = chalk.yellow
			local rawLines = Array.join({ "<div />" }, "\n")
			jestExpect(
				HttpService:JSONEncode(
					codeFrame(rawLines, 0, nil, { linesAbove = 1, linesBelow = 1, forceColor = true })
				)
			).toEqual(
				HttpService:JSONEncode(
					chalk.reset(
						" "
							.. gutter(" 1 |")
							.. " "
							.. yellow("<")
							.. yellow("div")
							.. " "
							.. yellow("/")
							.. yellow(">")
					)
				)
			)
		end)
		it("basic usage, new API", function()
			local rawLines = Array.join({ "class Foo {", "  constructor()", "};" }, "\n")
			jestExpect(codeFrameColumns(rawLines, { start = { line = 2, column = 16 } })).toEqual(Array.join({
				"  1 | class Foo {",
				"> 2 |   constructor()",
				"    |                ^",
				"  3 | };",
			}, "\n"))
		end)
		it("mark multiple columns", function()
			local rawLines = Array.join({ "class Foo {", "  constructor()", "};" }, "\n")
			jestExpect(
				codeFrameColumns(rawLines, { start = { line = 2, column = 3 }, ["end"] = { line = 2, column = 16 } })
			).toEqual(Array.join({
				"  1 | class Foo {",
				"> 2 |   constructor()",
				"    |   ^^^^^^^^^^^^^",
				"  3 | };",
			}, "\n"))
		end)
		it("mark multiple columns across lines", function()
			local rawLines = Array.join({ "class Foo {", "  constructor() {", "  }", "};" }, "\n")
			jestExpect(
				codeFrameColumns(rawLines, { start = { line = 2, column = 17 }, ["end"] = { line = 3, column = 3 } })
			).toEqual(Array.join({
				"  1 | class Foo {",
				"> 2 |   constructor() {",
				"    |                 ^",
				"> 3 |   }",
				"    | ^^^",
				"  4 | };",
			}, "\n"))
		end)
		it("mark multiple columns across multiple lines", function()
			local rawLines = Array.join(
				{ "class Foo {", "  constructor() {", "    console.log(arguments);", "  }", "};" },
				"\n"
			)
			jestExpect(
				codeFrameColumns(rawLines, { start = { line = 2, column = 17 }, ["end"] = { line = 4, column = 3 } })
			).toEqual(Array.join({
				"  1 | class Foo {",
				"> 2 |   constructor() {",
				"    |                 ^",
				"> 3 |     console.log(arguments);",
				"    | ^^^^^^^^^^^^^^^^^^^^^^^^^^^",
				"> 4 |   }",
				"    | ^^^",
				"  5 | };",
			}, "\n"))
		end)
		it("mark across multiple lines without columns", function()
			local rawLines = Array.join(
				{ "class Foo {", "  constructor() {", "    console.log(arguments);", "  }", "};" },
				"\n"
			)
			jestExpect(codeFrameColumns(rawLines, { start = { line = 2 }, ["end"] = { line = 4 } })).toEqual(
				Array.join({
					"  1 | class Foo {",
					"> 2 |   constructor() {",
					"> 3 |     console.log(arguments);",
					"> 4 |   }",
					"  5 | };",
				}, "\n")
			)
		end)
		it("opts.message", function()
			local rawLines = Array.join({ "class Foo {", "  constructor()", "};" }, "\n")
			jestExpect(codeFrameColumns(rawLines, { start = { line = 2, column = 16 } }, { message = "Missing {" })).toEqual(
				Array.join({
					"  1 | class Foo {",
					"> 2 |   constructor()",
					"    |                ^ Missing {",
					"  3 | };",
				}, "\n")
			)
		end)
		it("opts.message without column", function()
			local rawLines = Array.join({ "class Foo {", "  constructor()", "};" }, "\n")
			jestExpect(codeFrameColumns(rawLines, { start = { line = 2 } }, { message = "Missing {" })).toEqual(
				Array.join({ "  Missing {", "  1 | class Foo {", "> 2 |   constructor()", "  3 | };" }, "\n")
			)
		end)
		it("opts.message with multiple lines", function()
			local rawLines = Array.join(
				{ "class Foo {", "  constructor() {", "    console.log(arguments);", "  }", "};" },
				"\n"
			)
			jestExpect(
				codeFrameColumns(
					rawLines,
					{ start = { line = 2, column = 17 }, ["end"] = { line = 4, column = 3 } },
					{ message = "something about the constructor body" }
				)
			).toEqual(Array.join({
				"  1 | class Foo {",
				"> 2 |   constructor() {",
				"    |                 ^",
				"> 3 |     console.log(arguments);",
				"    | ^^^^^^^^^^^^^^^^^^^^^^^^^^^",
				"> 4 |   }",
				"    | ^^^ something about the constructor body",
				"  5 | };",
			}, "\n"))
		end)
		it("opts.message with multiple lines without columns", function()
			local rawLines = Array.join(
				{ "class Foo {", "  constructor() {", "    console.log(arguments);", "  }", "};" },
				"\n"
			)
			jestExpect(
				codeFrameColumns(
					rawLines,
					{ start = { line = 2 }, ["end"] = { line = 4 } },
					{ message = "something about the constructor body" }
				)
			).toEqual(Array.join({
				"  something about the constructor body",
				"  1 | class Foo {",
				"> 2 |   constructor() {",
				"> 3 |     console.log(arguments);",
				"> 4 |   }",
				"  5 | };",
			}, "\n"))
		end)
	end)
end
