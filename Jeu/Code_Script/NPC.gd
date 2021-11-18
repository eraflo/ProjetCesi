extends StaticBody

var can_interact = false
var DIALOG = preload("res://Scènes/DialogBox.tscn")
var Player_path = preload("res://Scènes/Player.tscn")
var distancePlayer

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
	



