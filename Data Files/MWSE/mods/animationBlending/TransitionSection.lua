local easing = require("animationBlending.easing")


--- Transition context for each body section.
---
---@class TransitionSection
---@field rule BlendRule?
---@field startTime number
---@field transforms table<niAVObject, { translation: tes3vector3, rotation: niQuaternion, scale: number }>
local TransitionSection = {}
TransitionSection.__index = TransitionSection


--- Create a new TransitionSection instance.
---
---@return TransitionSection
function TransitionSection.new()
    return setmetatable({ startTime = 0, transforms = {} }, TransitionSection)
end


--- Apply transform blending to this section.
---
---@param time number
---@return boolean
function TransitionSection:applyAnimationBlending(time)
    if self.rule == nil then
        return false
    end

    local factor = (time - self.startTime) / self.rule.duration
    if factor >= 1.0 then
        return false
    end

    local fn = easing[self.rule.easing]
    factor = fn(factor)

    for node, transform in pairs(self.transforms) do
        node.translation = transform.translation:lerp(node.translation, factor)
        node.rotation = transform.rotation:slerp(node.rotation:toQuaternion(), factor):toRotation()
        node.scale = math.lerp(transform.scale, node.scale, factor)
    end

    return true
end


--- Capture the current animation transforms of the given reference.
---
---@param ref tes3reference
---@param bodySection tes3.animationBodySection
function TransitionSection:captureTransforms(ref, bodySection)
    self:clearTransforms()

    local animation = ref.attachments.animation
    if animation == nil then
        return
    end

    local layerIndex = animation.currentAnimGroupLayers[bodySection + 1]
    local layer = animation.keyframeLayers[layerIndex + 1]
    local sequence =
        (bodySection == tes3.animationBodySection.lower) and layer.lower
        or (bodySection == tes3.animationBodySection.upper) and layer.upper
        or (bodySection == tes3.animationBodySection.leftArm) and layer.leftArm

    if not sequence then
        return
    end

    for _, controller in ipairs(sequence.controllers) do
        local target = controller and controller.target
        if target and target ~= animation.modelRootNode then
            self.transforms[target] = {
                translation = target.translation:copy(),
                rotation = target.rotation:toQuaternion(),
                scale = target.scale,
            }
        end
    end
end


--- Clear all captured transforms.
---
function TransitionSection:clearTransforms()
    table.clear(self.transforms)
end


return TransitionSection
