extends OmniLight

export var drain := 0.1
export var enable_drain := true
export var light_cutoff_threshold = 1.75
var starting_light_range = omni_range
var sprite
var interpolation_amt = 0
var white = Color(1, 1, 1, 1)
var darkmode = Color(0.1, 0.02, 0.09, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_parent().get_node("AnimatedSprite3D")
func _physics_process(delta):
	if enable_drain:
		if omni_range >= light_cutoff_threshold:
			omni_range -= drain * delta
			interpolation_amt = (starting_light_range - omni_range)/(starting_light_range - light_cutoff_threshold)
			sprite.set_modulate(white.linear_interpolate(darkmode, interpolation_amt))
		else:
			sprite.set_modulate(darkmode)
			visible = false
