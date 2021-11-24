extends SpringArm

var change

export var mouse_sensibility = 0.05

func _ready():
	if change == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(delta):
	if change == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _on_Player_change(value):
	change = value
