# A not completley scuffed keyframe system for hmi
Please come with ideas if you have any

## How to use
1. Copy the Keyframe code from AllTheFunctions.lua and paste it somewhere in your code
2. Call the Keyframe function once and pass a table containing your keyframe sequence (see the classes for structure)

### Example usage
```lua
local deltaTime = context.deltaTime

global.keyframeSequences = {};
global.nextSequenceId = 0;
global.debounce = false;

if not debounce then
    debounce = true

    playKeyframeSequence({
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
```
This example would first move the item with an inward back ease over 1 second then move it with no ease over 2 seconds



# Credit
-- // ✦ Made by maingvaldsen ✦ \\ --
