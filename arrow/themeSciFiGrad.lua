local color      = require( "gears.color"    )
local surface    = require( "gears.surface"  )
local themeutils = require( "blind.common.drawing"    )
local blind      = require( "blind"          )
local radical    = require( "radical"        )
local debug      = debug
local cairo      = require( "lgi"            ).cairo
local pango      = require( "lgi"            ).Pango
local blind_pat  = require( "blind.common.pattern" )
local wibox_w    = require( "wibox.widget"   )
local debug      = debug

local path = debug.getinfo(1,"S").source:gsub("theme.*",""):gsub("@","")

local theme = blind.theme

------------------------------------------------------------------------------------------------------
--                                                                                                  --
--                                    DEFAULT COLORS, FONT AND SIZE                                 --
--                                                                                                  --
------------------------------------------------------------------------------------------------------

local default_height = 16

theme.default_height = default_height

local function d_mask(img,cr)
    return blind_pat.to_pattern(blind_pat.mask.ThreeD(img,cr))
end

theme.path = path

-- Background
theme.bg = blind {
    normal      = "#000000",
    focus       = "#496477",
    urgent      = "#5B0000",
    minimize    = "#040A1A",
    highlight   = "#0E2051",
    alternate   = "#081B37",
    allinone    = { type = "linear", from = { 0, 0 }, to = { 0, 20 }, stops = { { 0, "#1D4164" }, { 1, "#0D2144" }}},
}

-- Wibar background
local bargrad = { type = "linear", from = { 0, 0 }, to = { 0, 16 }, stops = { { 0, "#000000" }, { 1, "#040405" }}}
theme.bar_bg = blind {
    alternate = d_mask(blind_pat.mask.noise(0.04,"#AAAACC", blind_pat.sur.plain("#081B37",default_height))),
    normal    = d_mask(blind_pat.sur.flat_grad(bargrad,"#1C1C22",default_height)),
    buttons   = d_mask(blind_pat.sur.flat_grad("#00091A","#04204F",default_height)),
}

-- Forground
theme.fg = blind {
    normal   = "#6DA1D4",
    focus    = "#ABCCEA",
    urgent   = "#FF7777",
    minimize = "#1577D3",
}

-- Other
theme.awesome_icon         = path .."Icon/awesome2.png"
theme.systray_icon_spacing = 4
theme.button_bg_normal     = color.create_png_pattern(path .."Icon/bg/menu_bg_scifi.png"       )
theme.enable_glow          = true
theme.glow_color           = "#105A8B"
theme.naughty_bg           = theme.bg_alternate
theme.naughty_border_color = theme.fg_normal
theme.bg_dock              = color.create_png_pattern(path .."Icon/bg/bg_dock.png"             )
theme.fg_dock_1            = "#1889F2"
theme.fg_dock_2            = "#0A3E6E"
theme.bg_systray           = theme.fg_normal
theme.bg_resize_handler    = "#aaaaff55"

-- Border
theme.border = blind {
    width  = 1         ,
    normal = "#1F1F1F" ,
    focus  = "#535d6c" ,
    marked = "#91231c" ,
}

theme.alttab_icon_transformation = function(image,data,item)
--     return themeutils.desaturate(surface(image),1,theme.default_height,theme.default_height)
    return surface.tint(surface(image),color(theme.fg_normal),theme.default_height,theme.default_height)
end

theme.icon_grad        = d_mask(blind_pat.mask.noise(0.4,"#777788", blind_pat.sur.plain("#507289",default_height)))
theme.icon_mask        = { type = "linear", from = { 0, 0 }, to = { 0, 20 }, stops = { { 0, "#8AC2D5" }, { 1, "#3D619C" }}}
theme.icon_grad_invert = { type = "linear", from = { 0, 0 }, to = { 0, 20 }, stops = { { 0, "#000000" }, { 1, "#112543" }}}


-- Taglist
theme.taglist = blind {
    bg = blind {
        hover     = d_mask(blind_pat.sur.thick_stripe("#19324E","#132946",14,default_height,true)),
        selected  = d_mask(blind_pat.sur.thick_stripe("#0D3685","#05297F",4 ,default_height,true)),
        used      = d_mask(blind_pat.sur.flat_grad("#00143B","#052F77",default_height)),
        urgent    = d_mask(blind_pat.sur.flat_grad("#5B0000","#300000",default_height)),
        changed   = d_mask(blind_pat.sur.flat_grad("#4D004D","#210021",default_height)),
        empty     = d_mask(blind_pat.sur.flat_grad("#090B10","#181E39",default_height)),
        highlight = "#bbbb00"
    },
    fg = blind {
        selected  = "#ffffff",
        used      = "#7EA5E3",
        urgent    = "#FF7777",
        changed   = "#B78FEE",
        highlight = "#000000",
        prefix    = theme.bg_normal,
    },
    custom_color = function (...) d_mask(blind_pat.sur.flat_grad(...)) end,
    default_icon       = path .."Icon/tags/other.png",
}
theme.taglist_bg                 = d_mask(blind_pat.sur.plain("#070A0C",default_height))

-- Tasklist
theme.tasklist = blind {
    underlay_bg_urgent      = "#ff0000",
    underlay_bg_minimized   = "#4F269C",
    underlay_bg_focus       = "#0746B2",
    bg_image_selected       = d_mask(blind_pat.sur.flat_grad("#00091A","#04204F",default_height)),
    bg_minimized            = d_mask(blind_pat.sur.flat_grad("#0E0027","#04000E",default_height)),
    fg_minimized            = "#985FEE",
    bg_urgent               = d_mask(blind_pat.sur.flat_grad("#5B0000","#070016",default_height)),
    bg_hover                = d_mask(blind_pat.sur.thick_stripe("#19324E","#132946",14,default_height,true)),
    bg_focus                = d_mask(blind_pat.sur.flat_grad("#00143B","#052F77",default_height)),
    default_icon            = path .."Icon/tags/other.png",
    bg                      = "#00000088",
    icon_transformation     = loadfile(theme.path .."bits/icon_transformation/state.lua")(theme,path)
}


-- Menu
theme.menu = blind {
    submenu_icon = path .."Icon/tags/arrow.png",
    height       = 20,
    width        = 170,
    border_width = 2,
    opacity      = 0.9,
    fg_normal    = "#ffffff",
    bg_focus     = color.create_png_pattern(path .."Icon/bg/menu_bg_focus_scifi.png" ),
    bg_header    = color.create_png_pattern(path .."Icon/bg/menu_bg_header_scifi.png"),
    bg_normal    = color.create_png_pattern(path .."Icon/bg/menu_bg_scifi.png"       ),
    bg_highlight = color.create_png_pattern(path .."Icon/bg/menu_bg_highlight.png"   ),
    border_color = theme.fg_normal,
}

-- Shorter
theme.shorter = blind {
--     bg = blind_pat.to_pattern(blind_pat.mask.noise(0.14,"#AAAACC", blind_pat.mask.triangle(80,3,{color("#0D1E37"),color("#122848")},"#25324A",blind_pat.sur.plain("#081B37",80))))
    bg = blind_pat.to_pattern(blind_pat.mask.noise(0.14,"#AAAACC", blind_pat.mask.triangle(80,3,{color("#091629"),color("#0E2039")},"#25324A",blind_pat.sur.plain("#081B37",79))))
}

-- theme.draw_underlay = themeutils.draw_underlay


-- Titlebar
loadfile(theme.path .."bits/titlebar.lua")(theme,path)
theme.titlebar = blind {
    bg_normal = d_mask(blind_pat.mask.noise(0.02,"#AAAACC", blind_pat.sur.plain("#070A0C",default_height))),
    bg_focus  = d_mask(blind_pat.sur.flat_grad("#2A2A32",nil,default_height))
}

-- Layouts
loadfile(theme.path .."bits/layout.lua")(theme,path)

-- Textbox glow
loadfile(theme.path .."bits/textbox/glow.lua")(theme,path)

-- The separator theme
require( "chopped.arrow" )

-- Add round corner to floating clients
loadfile(theme.path .."bits/client_shape.lua")(3)

return theme