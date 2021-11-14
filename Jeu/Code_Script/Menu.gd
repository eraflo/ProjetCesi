extends Control


func _ready():
	GameManager.do_load()

#envoie dans la scène World
func _on_PlayButton_pressed():
	GameManager.do_save()
	GameManager.playing = true
	GameManager.autosave_start_time = OS.get_unix_time()
	get_tree().change_scene("res://Scènes/World.tscn")
