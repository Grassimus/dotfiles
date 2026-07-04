hl.config({
	decoration = {
		rounding = 8,
		blur = {
			enabled = true,
			size = 3,
			passes = 2,
		},
		shadow = {
			enabled = true,
			range = 12,
			render_power = 3,
			color = "rgba(00000046)",
		},
	},
})

hl.layer_rule({
	match = {
		namespace = "gtk4-layer-shell",
	},
	blur = true,
	blur_popups = true,
	ignore_alpha = 0.29,
	no_anim = true,
})
