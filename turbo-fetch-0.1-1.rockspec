package = "turbo-fetch"
version = "0.1-1"

source = {
 url = "",
 branch = "master"
}

description = {
 summary = "Turbo.lua callback-compatible alternative for turbo.async.HTTPClient():fetch",
 detailed = [[
Turbo.lua callback-compatible alternative for turbo.async.HTTPClient():fetch
]],
 homepage = "",
 license = "MIT"
}

dependencies = {
 "turbo"
}

build = {
 type = "builtin",
 modules = {
  ["turbo-fetch"] = "turbo-fetch.lua"
 },
 copy_directories = {}
}