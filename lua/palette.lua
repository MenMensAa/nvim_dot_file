local custom_palette = {}
local onedark_palette = require("onedark.palette").dark

local palette = {
	bg_l = "#2d3039",
	bg4 = "#434856",
	bg5 = "#656c81",
}

local function insert_color(t)
	for k, v in pairs(t) do
		palette[k] = v
	end
end

insert_color(onedark_palette)
insert_color(custom_palette)

return palette
