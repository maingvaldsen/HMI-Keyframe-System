local deltaTime = context.deltaTime

global.keyframeSequences = {};
global.nextSequenceId = 1;
global.debounce = false;
global.id = nil;



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

if not debounce then
    debounce = true

    id = playKeyframeSequence({
        {
            startTime = 1,
            endTime = 2,
            from = {
                position = {x = 0, y = 0, z = 0},
            },
            to = {
                position = {x = -0.3, y = 0, z = -0.1},
            },
            easing = function(t) return Easings:easeInBack(t) end
        },
        {
            startTime = 2,
            endTime = 4,
            from = {
                position = {x = -0.3, y = 0, z = -0.1},
            },
            to = {
                position = {x = -0.7, y = 1, z = -0.78},
            },
        },
    })
end

if id then
    advanceSequence(id, 3)
end