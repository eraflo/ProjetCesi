extends Area
signal can_interact(value)

var can_interact = false
const DIALOG = preload("res://Scènes/DialogBox.tscn")


func _physics_process(delta):
	pass

func _on_NPC_body_entered(body):
	if body.name == "Player" :
		$Label.visible = true
		can_interact = true


func _on_NPC_body_exited(body):
	if body.name == "Player" :
		$Label.visible = false
		can_interact = false

func _input(event):
	if Input.is_key_pressed(KEY_ENTER) and can_interact == true:
		$Label.visible = false
		var dialog = DIALOG.instance()
		get_parent().add_child(dialog)
		get_tree().paused = true



