---@class Vector3 Table containing x, y, z
---@field x number
---@field y number
---@field z number

---@class KeyframeTransform Table containing position, rotation, scale
---@field position Vector3|nil
---@field rotation Vector3|nil
---@field scale Vector3|nil

---@class Keyframe
---@field startTime number
---@field endTime number
---@field fromIndex number|nil
---@field toIndex number|nil
---@field from KeyframeTransform
---@field to KeyframeTransform
---@field easing function|nil You have to wrap the easing in a fucntion (e.g. easing = function(t) return Easings:easeInBack(t) end)

---@class KeyframeSequence : table<number, Keyframe>



-- // |█| ===██===██===██===██===██===██=== |█| \\ --
-- // |█|          Keyframe System          |█| \\ --
-- // |█| ===██===██===██===██===██===██=== |█| \\ --



-- // Requires these variables \\ --
local deltaTime = context.deltaTime -- replace context with data if its for model part animations
global.keyframeSequences = {};
global.nextSequenceId = 0;

---Keyframe function for making animations without math.                                                        
----- // ✦ Made by maingvaldsen ✦ \\ --
---@param sequence KeyframeSequence
---@return number id The id of the sequence
local function playKeyframeSequence(sequence)
    local id = nextSequenceId
    nextSequenceId = id + 1

    keyframeSequences[id] = {
        clock = 0,
        sequence = sequence,
    }

    return id
end
local function evaluateSequence(sequence, time)
    for _, key in ipairs(sequence) do
        if time >= key.startTime and time <= key.endTime then
            local rawTime = (time - key.startTime) / (key.endTime - key.startTime)

            local t = rawTime
            if key.easing then
                t = key.easing(rawTime)
            end

            local tempResult = {
                position = {x = 0, y = 0, z = 0},
                rotation = {x = 0, y = 0, z = 0},
                scale = {x = 1, y = 1, z = 1},
            }

            if key.from.position and key.to.position then
                tempResult.position.x = M:lerp(t, key.from.position.x, key.to.position.x)
                tempResult.position.y = M:lerp(t, key.from.position.y, key.to.position.y)
                tempResult.position.z = M:lerp(t, key.from.position.z, key.to.position.z)
            end

            if key.from.rotation and key.to.rotation then
                tempResult.rotation.x = M:lerp(t, key.from.rotation.x, key.to.rotation.x)
                tempResult.rotation.y = M:lerp(t, key.from.rotation.y, key.to.rotation.y)
                tempResult.rotation.z = M:lerp(t, key.from.rotation.z, key.to.rotation.z)
            end

            if key.from.scale and key.to.scale then
                tempResult.scale.x = M:lerp(t, key.from.scale.x, key.to.scale.x)
                tempResult.scale.y = M:lerp(t, key.from.scale.y, key.to.scale.y)
                tempResult.scale.z = M:lerp(t, key.from.scale.z, key.to.scale.z)
            end

            return tempResult
        end
    end

    return nil
end
---@param id number the id of the sequence you want to advance
---@param time number|nil optional point in the sequence if you want to control it yourself
local function advanceSequence(id, time)
    local data = keyframeSequences[id]
    data.clock = time or data.clock + deltaTime

    local result = evaluateSequence(data.sequence, data.clock)

    if result then
        if result.fromIndex and result.toIndex then
            animator:moveX(result.fromIndex, result.toIndex, result.position.x)
            animator:moveY(result.fromIndex, result.toIndex, result.position.y)
            animator:moveZ(result.fromIndex, result.toIndex, result.position.z)

            animator:rotateX(result.fromIndex, result.toIndex, result.rotation.x)
            animator:rotateY(result.fromIndex, result.toIndex, result.rotation.y)
            animator:rotateZ(result.fromIndex, result.toIndex, result.rotation.z)

            animator:scale(result.fromIndex, result.toIndex, result.scale.x, result.scale.y, result.scale.z)
        else
            M:translate(context.matrices, result.position.x, result.position.y, result.position.z)

            M:rotateX(context.matrices, result.rotation.x)
            M:rotateY(context.matrices, result.rotation.y)
            M:rotateZ(context.matrices, result.rotation.z)

            M:scale(context.matrices, result.scale.x, result.scale.y, result.scale.z)
        end
    end
end



-- // |█| ===██===██===██====██===██===██=== |█| \\ --
-- // |█|       Quadratic Beziér curve       |█| \\ --
-- // |█| ===██===██===██====██===██===██=== |█| \\ --



---3D Quadratic Beziér curve                                                                                    
---Depends on the vector3Lerp function
---@param p0 Vector3 table containing p0 (e.g. {x = 1, y = 2, z = 1})
---@param p1 Vector3 table containing p1 (e.g. {x = 1, y = 2, z = 1})
---@param p2 Vector3 table containing p2 (e.g. {x = 1, y = 2, z = 1})
---@param time number the point in the curve from 0 - 1
---@return number x the X position of the point in the curve
---@return number y the Y position of the point in the curve
---@return number z the Z position of the point in the curve
local function quadraticBezier(p0, p1, p2, time)
    local function vector3Lerp(a, b, t)
        return {
            x = M:lerp(t, a.x, b.x),
            y = M:lerp(t, a.y, b.y),
            z = M:lerp(t, a.z, b.z),
        }
    end

    local a = vector3Lerp(p0, p1, time)
    local b = vector3Lerp(p1, p2, time)
    local c = vector3Lerp(a, b, time)
    return c.x, c.y, c.z
end