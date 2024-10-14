--- @meta
--- This is the luals type definition file for all of the sliden builtins

--- @class Connection
--- @field id string
--- @field connected boolean
--- @field is_presenter boolean
Connection = {}

---gets the variable from the given key
---@param key string
---@return string
function Connection:get_var(key) end
---sets the variable of the given key to the given value
---@param key string
---@param value string
function Connection:set_var(key, value) end

---gets the private variable from the given key
---@param key string
---@return any
function Connection:get_priv_var(key) end
---sets the private variable of the given key to the given value
---@param key string
---@param value any
function Connection:set_priv_var(key, value) end

--- re-sends all the variable assignments to the connection
function Connection:update() end

--- @class Slide
Slide = {}

--- @param template string
--- @return Slide
function Slide:template(template) end

--- @param title string
--- @return Slide
function Slide:title(title) end

--- @param title string
--- @return Slide
function Slide:title(title) end

--- @param id string
--- @param show boolean
--- @param action fun(who: Connection)
--- @return Slide
function Slide:action(id, show, action) end

---runs a function before a slide is loaded.
---return `false` to prevent loading this slide
---@param fn fun(): boolean?
function Slide:on_before(fn) end

---runs a function before going to the next slide.
---return `false` to prevent leaving this slide
---@param fn fun(): boolean?
function Slide:on_after(fn) end

--- @class Sliden
Sliden = {}

--- creates a new slide
--- @param id string
--- @return Slide
function Sliden:slide(id) end

--- returns a list of connection ids
--- @return string[]
function Sliden:connections() end

---gets the connection `id`
---@param id string
---@return Connection
function Sliden:connection(id) end

--- sends variable updates to all the connections
function Sliden:update_all() end

--- the main sliden singleton
--- @type Sliden
sliden = nil
