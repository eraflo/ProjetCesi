extends CanvasLayer

onready var health_bar = $ColorStat/Life/HealthBar

func _ready():
	pass

func _on_health_up(health):
	health_bar.value = health

func _on_max_health_updated(max_health):
	health_bar.max_value = max_health



func _on_back_inventorie_pressed():
	queue_free()
	get_tree().paused = false
