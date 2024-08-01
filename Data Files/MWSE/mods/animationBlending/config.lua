---@class AnimationBlendingConfig
---@field enabled boolean
---@field playerOnly boolean
---@field maxDistance number
---@field logLevel string
---@field blocked { [string]: boolean }

local config = mwse.loadConfig("animationBlending", {
    enabled = true,
    playerOnly = false,
    maxDistance = 4096,
    logLevel = "INFO",
    blocked = {},
})

return config --[[@as AnimationBlendingConfig]]
