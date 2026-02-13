local deltaTime = context.deltaTime -- Remove this line if you want to use it on hmi versions before 5.1 and replace context with data if its for model part anims
global.tweens = {};
---Keyframe function for making animations without math.                                                        
----- // ✦ Made by maingvaldsen ✦ \\ --
---@param tweenId number an id for your tween so you can have multiple tweens running at once and access them later
---@param amount number the amount it should tween
---@param time number how long it should take to tween to the new location
---@return number tween the items new position (updated every frame the tween is called)
local function tween(tweenId, amount, time)
    if not tweens[tweenId] then
        tweens[tweenId] = {clock = 0}
    end

    tweens[tweenId].clock = tweens[tweenId].clock + deltaTime

    local progress = M:clamp(tweens[tweenId].clock / time, 0, 1)
    local moveValue = amount * progress

    if progress >= 1 then tweens[tweenId] = nil end

    return moveValue
end