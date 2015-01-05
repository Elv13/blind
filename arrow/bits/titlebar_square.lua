local theme,path = ...
local surface    = require( "gears.surface"      )
local blind      = require( "blind"              )
local shape      = require( "blind.common.shape" )
local color      = require( "gears.color"        )
local cairo      = require( "lgi"                ).cairo
local pixmap     = require( "blind.common.pixmap")

local active = theme.titlebar_icon_active or theme.titlebar_icon_fg or theme.fg_normal
local height = theme.titlebar_height
local base_square = {}

local square = nil

local function get_cols(state)
    return color(theme["titlebar_bg_"..state]),color(theme["titlebar_border_color_"..state])
end

local function gen_squares()
    for _,v in ipairs {"inactive","active", "hover", "pressed"} do
        local bg,border = get_cols(v)
        local img = cairo.ImageSurface.create(cairo.Format.ARGB32, height-2, height)
        local cr  = cairo.Context(img)
        if square then
            cr:append_path(square)
        else
            shape.draw_round_rect(cr,2,2,height-7,height-7,3)
            square = cr:copy_path()
        end
        cr:set_source(bg)
        cr:fill_preserve()
        cr:set_source(border)
        cr:set_line_width(2)
        cr:stroke()
        base_square[v] = img
        print(v)
    end
end
gen_squares()

local function add_icon(state,type,icon_path)
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, height-2, height)
    local cr  = cairo.Context(img)
    cr:set_source_surface(base_square[state])
    cr:paint()
    cr:set_source_surface(surface(icon_path or (path .."Icon/titlebar/".. type .."_normal_inactive.png")))
    cr:paint()
    return pixmap(img) : shadow() : to_img()
end

local close     = base_square.active
local ontop     = base_square.active
local sticky    = base_square.active
local floating  = base_square.active
local maximized = base_square.active

theme.titlebar = blind {
    close_button = blind {
        normal = add_icon("active","close",path .."Icon/titlebar/close_focus_inactive.png"),
        focus  = add_icon("hover","close",path .."Icon/titlebar/close_focus_inactive.png"),
    },

    ontop_button = blind {
        normal_inactive = add_icon("active","ontop"),
        focus_inactive  = add_icon("active","ontop"),
        normal_active   = add_icon("active","ontop"),
        focus_active    = add_icon("active","ontop"),
    },

    sticky_button = blind {
        normal_inactive = add_icon("active","sticky"),
        focus_inactive  = add_icon("active","sticky"),
        normal_active   = add_icon("active","sticky"),
        focus_active    = add_icon("active","sticky"),
    },

    floating_button = blind {
        normal_inactive = add_icon("active","floating"),
        focus_inactive  = add_icon("active","floating"),
        normal_active   = add_icon("active","floating"),
        focus_active    = add_icon("active","floating"),
    },

    maximized_button = blind {
        normal_inactive = add_icon("active","maximized"),
        focus_inactive  = add_icon("active","maximized"),
        normal_active   = add_icon("active","maximized"),
        focus_active    = add_icon("active","maximized"),
    },

    resize      = add_icon("active","maximized",path .."Icon/titlebar/resize.png"),
    tag         = add_icon("active","maximized",path .."Icon/titlebar/tag.png"),
    bg_focus    = theme.bg_normal,
    title_align = "left",
}