-- ROBLOX upstream: https://github.com/testing-library/dom-testing-library/blob/v8.14.0/types/pretty-dom.d.ts
local Packages = script.Parent.Parent.Parent

local exports = {}

local prettyFormat = require(Packages.PrettyFormat)
type prettyFormat_OptionsReceived = prettyFormat.OptionsReceived

export type PrettyDOMOptions = prettyFormat_OptionsReceived & {
	--[[*
       * Given a `Node` return `false` if you wish to ignore that node in the output.
       * By default, ignores `<style />`, `<script />` and comment nodes.
   ]]
	filterNode: ((node: Instance) -> boolean)?,
}

export type prettyDOM = (dom: Instance?, maxLength: number?, options: PrettyDOMOptions?) -> string | false

export type logDOM = (dom: Instance?, maxLength: number?, options: PrettyDOMOptions?) -> ()

export type Colors = prettyFormat.Colors
export type CompareKeys = prettyFormat.CompareKeys
export type Config = prettyFormat.Config
export type Options = prettyFormat.Options
export type OptionsReceived = prettyFormat.OptionsReceived
export type OldPlugin = prettyFormat.OldPlugin
export type NewPlugin = prettyFormat.NewPlugin
export type Plugin = prettyFormat.Plugin
export type Plugins = prettyFormat.Plugins
export type PrettyFormatOptions = prettyFormat.PrettyFormatOptions
export type Printer = prettyFormat.Printer
export type Refs = prettyFormat.Refs
export type Theme = prettyFormat.Theme

return exports
