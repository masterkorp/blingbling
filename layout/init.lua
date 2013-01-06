local setmetatable = setmetatable
local require = require

-- Widget layouts
return {
    margins = setmetatable({}, { __mode = 'k' }),
    array = require("blingbling.layout.array")
}

--- Widgets margins.
-- <p>In this table you can set the margin you want the layout to use when
-- positionning your widgets.
-- For example, if you want to put 10 pixel free on left on a widget, add this:
-- <code>
-- awful.widget.layout.margins[mywidget] = { left = 10 }
-- </code>
-- </p>
-- @name margins
-- @class table
