extends SpringArm

var change

export var mouse_sensibility = 0.05

func _ready():
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
#gère rotation caméra vue 3eme personne
func _unhandled_input(event):
	if change == true:
		if event is InputEventMouseMotion:
			rotation_degrees.x -= event.relative.y * mouse_sensibility
			rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
			
			rotation_degrees.y -= event.relative.x * mouse_sensibility
			rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

func _process(delta):
	if change == true and !Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if change == false and Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	


func _on_Player_change(value):
	change = value
