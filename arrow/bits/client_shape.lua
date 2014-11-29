local capi      = {client=client}
local shape     = require("blind.common.shape" )
local beautiful = require("beautiful"          )
local cairo     = require( "lgi"               ).cairo
local client    = require( "awful.client"      )
local cshape    = require( "awful.client.shape")
local surface   = require("gears.surface")

local active = setmetatable({},{__mode="k"})

local function create(c)
    local geo = c:geometry()
    local border = beautiful.border_width
    local width,height = geo.width,geo.height

    -- Add round corners to the client
    local img  = cairo.ImageSurface.create(cairo.Format.A8, width+2*border, height+2*border)
    local cr = cairo.Context(img)
    cr:set_antialias(cairo.ANTIALIAS_NONE)

--     cr:set_source_rgba(0,0,0,0)
--     cr:paint()

    cr:set_operator(cairo.Operator.SOURCE)
    cr:set_source_rgba(1,1,1,1)
    shape.draw_round_rect2(cr,0,0,width+2*border,height+2*border,10,10,5,5)
    cr:fill()

    c.shape_bounding = img._native
    img:finish()

    -- Fix the border mask to incluse the round corners
    img  = cairo.ImageSurface.create(cairo.Format.A8, width+2*border, height+2*border)
    local cr = cairo.Context(img)
    cr:set_antialias(cairo.ANTIALIAS_NONE)
    cr:set_source_rgba(0,0,0,0)
    cr:paint()
    cr:set_operator(cairo.Operator.SOURCE)
    cr:set_source_rgba(1,1,1,1)

    shape.draw_round_rect2(cr,0,0,width,height,10,10,5,5)
    cr:fill()
    c.shape_clip = img._native
    img:finish()

end

-- Disconnect the old, avoid double shape painting
capi.client.disconnect_signal("property::width", cshape.update.all)
capi.client.disconnect_signal("property::height", cshape.update.all)


capi.client.connect_signal("property::floating",function(c)
    active[c] = client.floating.get(c)
end)

capi.client.connect_signal("property::width",function(c)
    if active[c] then
        create(c)
    else
        cshape.update.all(c)
    end
end)

capi.client.connect_signal("property::height",function(c)
    if active[c] then
        create(c)
    else
        cshape.update.all(c)
    end
end)