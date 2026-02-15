# A very scuffed keyframe system for hmi
Please come with ideas if you have any (planning on making easings work, this is just a quick concept for now)

## How to use
1. Copy the tween code from TweenFunction.lua and paste it somewhere in your code
2. Call the tween function and pass a unique id for that tween, the amount you want to move it and how long it should take
3. Do something with the value it returns

### Example usage
_Dont copy the tween function from here, this is never gona be up to date. Get it from releases_
```lua
local matrices = context.matrices
local deltaTime = context.deltaTime

global.tweens = {};

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

M:moveX(matrices, tween(1, 0.5, 1.3))
```
This example would move the item by 0.5 on the X axis over 1.3 seconds



# Credit
-- // ✦ Made by maingvaldsen ✦ \\ --
