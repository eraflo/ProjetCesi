extends Node

onready var settingsmenu = load("res://Scènes/ParamMenu.tscn")
onready var settingsmenuchar = load("res://Scènes/CharacterMenu.tscn")
var filepath = "res://keybind.ini"
var configfile

var keybinds = {}

#gère l'apparition de nos fenêtre 
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		add_child(settingsmenu.instance())
		get_tree().paused = true
	if Input.is_key_pressed(KEY_I):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		add_child(settingsmenuchar.instance())
		get_tree().paused = true
		
	

#gère la récupération des données contenues dans notre fichier texte
func _ready():
	configfile = ConfigFile.new()
	if configfile.load(filepath) == OK:
		for key in configfile.get_section_keys("keybinds"):
			var key_value = configfile.get_value("keybinds", key)
			
			if str(key_value) != "":
				keybinds[key] = key_value
			else:
				keybinds[key] = null
	else:
		print("CONFIG FILE NOT FOUND")
		get_tree().quit()
	
	set_game_binds()

#gère l'écriture dans nos paramètres des modifications de keys
func set_game_binds():
	for key in keybinds.keys():
		var value = keybinds[key]
		
		var actionlist = InputMap.get_action_list(key)
		if !actionlist.empty():
			InputMap.action_erase_event(key, actionlist[0])
		
		if value != null:
			var new_key = InputEventKey.new()
			new_key.set_scancode(value)
			InputMap.action_add_event(key, new_key)
			

#gère l'écriture du nouveau keybind dans notre fichier texte
func write_config():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		if key_value != null:
			configfile.set_value("keybinds", key, key_value)
		else:
			configfile.set_value("keybinds", key, "")
	configfile.save(filepath)
