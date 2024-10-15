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
    "gru",
    "puppies",
    "spooky",
    "america",
    "hideous themed",
    "your sport",
    "favorite artist",
    "banana"
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

s:slide("template")
    :title("Download Template")
    :template("download")

s:slide("connecting")
    :title("Connecting to the Socket")
    :template("connecting")
    :action("show code", true, function (who)
        for _, conn in ipairs(s:connections()) do
            s:connection(conn):set_var("code_shown", "block")
        end
        s:update_all()
    end)
    :on_before(function ()
        for _, conn in ipairs(s:connections()) do
            s:connection(conn):set_var("code_shown", "none")
        end
    end)

s:slide("events")
    :title("WebSocket Events")
    :template("events")

s:slide("events_code")
    :title("WebSocket Events (Code)")
    :template("events_code")

local function set_all(name, val)
    for _, c in ipairs(s:connections()) do
        s:connection(c):set_var(name, val)
    end
end

s:slide("messages")
    :title("Types of Messages")
    :template("message_types")
    :action("msg", true, function (_)
        set_all("msg", "block")
        s:update_all()
    end)
    :action("welcome", true, function (_)
        set_all("welcome", "block")
        s:update_all()
    end)
    :action("login", true, function (_)
        set_all("login", "block")
        s:update_all()
    end)
    :action("receive message", true, function (_)
        set_all("recv_msg", "block")
        s:update_all()
    end)

s:slide("logging_in")
    :title("Logging in")
    :template("logging_in")
    :action("show code", true, function (_)
        set_all("codedisplay", "block")
        s:update_all()
    end)
    :action("emphasize open", true, function (_)
        set_all("fontweight", "bold")
        s:update_all()
    end)

s:slide("receiving_data")
    :title("Receiving Data")
    :template("receiving_data")
    :action("show code", true, function (_)
        set_all("codedisplay2", "block")
        s:update_all()
    end)

s:slide("receiving_data_code")
    :template("receiving_data_code")
    :title("Extra Code for Receiving Data")

s:slide("sending_messages")
    :template("sending_messages")
    :title("Sending Messages")

s:slide("sending_messages_code")
    :template("sending_messages_code")
    :title("Code for Sending Messages")

s:slide("styling")
    :template("styling")
    :title("Styling!")
    :action("background", true, function (_)
        set_all("background_color", "f00")
        s:update_all()
    end)
    :action("color", true, function (_)
        set_all("color", "#0f0")
        s:update_all()
    end)
    :action("transform", true, function (_)
        set_all("transform", "scaleY(-1)")
        s:update_all()
    end)
    :action("animation", true, function (_)
        set_all("animation", "spin 2s linear infinite")
        s:update_all()
    end)
    :action("too much", true, function (_)
        set_all("animation", "none")
        set_all("transform", "none")
        s:update_all()
    end)
    :action("edit", true, function (_)
        set_all("contenteditable", "true")
        s:update_all()
    end)

s:slide("go")
    :template("go")
    :title("GO GO GO!")