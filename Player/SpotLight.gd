extends SpotLight


var drain = 0.1
var light_range = spot_range

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	
	if spot_range >= 3:
		spot_range -= drain * delta
		#print(light_range)
	else:
		visible = false
		#print(visible)
