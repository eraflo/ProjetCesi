extends Button

func _ready():
	pass # Replace with function body.

#envoie dans la scène World
func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scènes/World.tscn")
