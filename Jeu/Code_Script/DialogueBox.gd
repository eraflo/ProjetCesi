extends Control

#là où on a nos textes
var dialog = [
	'Hello my dear friend !',
	'My name is John, the clown',
	'I love joking'
]

var dialog_index = -1
var finished = false

#lance une fois le dialogue quand la scène se lance
func _ready():
	load_dialog()

#permet de relancer le dialogue quand on appuie sur "enter"
func _physics_process(delta):
	$"Ind".visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		load_dialog()

#fonction pour générer le dialogue et les effets qui vont avec
func load_dialog():
	if dialog_index < dialog.size():
		finished = false
		$RichTextLabel.bbcode_text = dialog[dialog_index]
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property(
			$RichTextLabel, "percent_visible", 0, 1, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		queue_free()
		get_tree().paused = false
	dialog_index += 1


func _on_Tween_tween_completed(object, key):
	finished = true
