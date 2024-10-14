--- @module "sliden"

local s = sliden

dofile("./base.lua")

s:slide("agenda")
    :template("agenda")
    :title("Agenda")

s:slide("end_goal")
    :template("end_goal")
    :title("End Goal")

s:slide("issue")
    :template("issue")
    :title("The Problem")

local themes = {
    "you don't get a theme",
    "rohan dalal + nuts",
    "halloween",
    "america",
    "hideous themed"
}

local function assignThemes()
    local conns = s:connections()
    local nextTheme = math.random(#themes)

    for i, id in ipairs(conns) do
        local conn = s:connection(id)
        conn:set_var("theme", themes[nextTheme])

        nextTheme = nextTheme + 1
        if nextTheme > #themes then
            nextTheme = 1
        end
    end
end

s:slide("solution")
    :template("solution")
    :title("The Solution (you)")
    :action("reroll", true, function (_)
        assignThemes()
        s:update_all()
    end)
    :action("big prize", true, function (_)
        for i, c in ipairs(s:connections()) do
            s:connection(c):set_var("prize_size", "8rem")
        end
        s:update_all()
    end)
    :on_before(function ()
        for i, c in ipairs(s:connections()) do
            s:connection(c):set_var("prize_size", "1rem")
        end
        assignThemes()
    end)