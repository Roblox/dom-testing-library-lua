#!/bin/bash

set -x

echo "Remove .robloxrc from dev dependencies"
find Packages/Dev -name "*.robloxrc" | xargs rm -f
find Packages/_Index -name "*.robloxrc" | xargs rm -f

echo "Run static analysis"
selene src
roblox-cli analyze analyze.project.json
stylua -c src

echo "Run tests"
roblox-cli run --load.place tests.project.json --run bin/spec.lua --lua.globals=__DEV__=true --fastFlags.allOnLuau --fastFlags.overrides EnableLoadModule=true --fs.read=$PWD --load.asRobloxScript --headlessRenderer 1 --virtualInput 1
