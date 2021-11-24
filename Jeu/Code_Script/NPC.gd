extends RigidBody

var can_interact = false
const DIALOG = preload("res://Scènes/DialogBox.tscn")

#là où on a nos textes
export var dialog = [
	'Hello my dear friend !',
	'My name is John, the clown',
	'I love joking'
]

#cacher "Interargir (Enter)"
func _input(event):
	if Input.is_key_pressed(KEY_ENTER) and can_interact == true:
		$Label.visible = false
		add_child(DIALOG.instance())
		get_tree().paused = true



