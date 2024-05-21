-- Initializing global variables to store the latest game state and game host process.

LatestGameState = LatestGameState or nil
Game = "0rVZYFxvfJpO__EfOz0_PUQ3GFE9kEaES0GkUDNXjvE"
CRED = "Sa0iBLPNyJQrwpTTG-tWLQU-1QeUAJA73DdxGGiKoJc"
Counter = Counter or 0

-- Checks if two points are within a given range.
-- @param x1, y1: Coordinates of the first point.
-- @param x2, y2: Coordinates of the second point.
-- @param range: The maximum allowed distance between the points.
-- @return: Boolean indicating if the points are within the specified range.

colors = {
    red = "\27[31m",
    green = "\27[32m"
}

function inRange(x1, y1, x2, y2, range)
    local distanceSquared = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)
    local inRange = distanceSquared <= range * range
    return inRange, distanceSquared
end

local x1, y1 = 5, 6
local x2, y2 = 8, 10

-- Maximum allowed range

local maxRange = 7

-- Check if both points are within the maximum allowed range

if inRange(x1, y1, x2, y2, maxRange) then
    print("Both points are within the maximum allowed range.")
else
    print("Both points are not within the maximum allowed range.")
end

function decideNextAction()
    local player = {
        x = 7, 
        y = 7, 
        energy = 20
    }
    local target = nil

    local otherPlayers = {
        { x = 5, y = 6, energy = 15 }, 
        { x = 8, y = 9, energy = 25 } 
    }

    -- Check if any opponent player is within range

    for _, opponent in ipairs(otherPlayers) do
        local inRange, distanceSquared = inRange(player.x, player.y, opponent.x, opponent.y, 1)
        if inRange then
            if opponent.energy <= 10 then
                -- Attack the nearest opponent player with energy less than or equal to 10

                print(colors.green .. "Player is within range. Attacking..." .. "\27[0m")
                return
            elseif opponent.energy > 20 then
                -- Retreat if there is an opponent player with energy greater than 20

                print(colors.red .. "Opponent player is above average. Retreating..." .. "\27[0m")
                return
            end
        end
    end

    -- If no opponent player meets the conditions, move randomly

    print(colors.red .. "Player has insufficient energy!" .. "\27[0m")
end

function emergencyEnergyCheck(player)
    if player.energy < 10 then
        print(colors.red .. "Player's energy is critically low! Emergency energy needed!" .. "\27[0m")
    end
end

Handlers.add(
    "ReturnAttack", 
    Handlers.utils.hasMatchingTag("Action", "Hit"),
    function(msg) 
        local playerEnergy = 20

        local enemyEnergy = 15 

        if playerEnergy > 10 then
            print("Returning attack...")
        else
            print(colors.red .. "Player has insufficient energy to return attack!" .. "\27[0m")
            emergencyEnergyCheck(playerEnergy)
        end
    end
)

Handlers.add(
    "StartTick",
    Handlers.utils.hasMatchingTag("Action", "Payment-Received"),
    function (msg)
        print("Game started! Let the ticking begin!")
    end
)