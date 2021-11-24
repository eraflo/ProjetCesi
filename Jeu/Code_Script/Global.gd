extends Node

onready var settingsmenu = load("res://Scènes/ParamMenu.tscn")
onready var settingsmenuchar = load("res://Scènes/CharacterMenu.tscn")
const DIALOG = preload("res://Scènes/DialogBox.tscn")
var filepath = "res://game_data/keybind.ini"
var configfile

var keybinds = {}

#détection scène actuelle
var sceneActuelle 

#gère la détection npc
var distancePlayer
onready var array_npc = []
var allDistancePlayer = []
var distanceMini = 10
var npcProche









#gère l'apparition de nos fenêtre 
func _input(event):
	#permet de vérifier qu'on est bien dans une scène où le joueur a droit d'ouvrir des fenêtres
	if sceneActuelle.size() > 0:
		#gère les apparitions de fenêtres quand appuie sur touches
		if Input.is_key_pressed(KEY_ESCAPE):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			add_child(settingsmenu.instance())
			get_tree().paused = true
		if Input.is_key_pressed(KEY_I):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			add_child(settingsmenuchar.instance())
			get_tree().paused = true
	if Input.is_key_pressed(KEY_ENTER) and array_npc[npcProche].can_interact == true:
		var label = array_npc[npcProche].get_node("Label")
		label.visible = false
		add_child(DIALOG.instance())
		




func _ready():
	#récupère la scène de départ pour voir la scène où on se trouve
	sceneActuelle = get_tree().get_nodes_in_group("level")
	
	
	#gère la récupération des données contenues dans notre fichier texte
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




func _physics_process(delta):
	##récupère la scène actuelle pour voir la scène où on se trouve 
	sceneActuelle = get_tree().get_nodes_in_group("level")
	
	
	#gère apparition des textes à une certaines distances des npc
	if len(array_npc) == 0:
		get_all_npc()
	get_distance()
	









##############    Touches Claviers      ############


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
	





##############    NPC      ############


#gère la récupération de tous les npc dans la scène
func get_all_npc():
	array_npc = get_tree().get_nodes_in_group("npc")

#gère le calcul de distance entre le player et le npc
func get_distance():
	var Player = get_tree().get_nodes_in_group("player")
	for i in range(array_npc.size()):
		var x = (Player[0].translation.x - array_npc[i].translation.x)
		var y = (Player[0].translation.y - array_npc[i].translation.y)
		var z = (Player[0].translation.z - array_npc[i].translation.z)
		distancePlayer = sqrt(x*x + y*y + z*z)
		if distancePlayer > 0:
			allDistancePlayer.append(distancePlayer)
	
	
	#détecte si le npc le plus proche est dans la zone d'interaction
	if allDistancePlayer.size() > 0:
		get_distance_mini(allDistancePlayer)
		
		if distanceMini < 10:
			array_npc[npcProche].can_interact = true
			var label = array_npc[npcProche].get_node("Label")
			label.visible = true
		else:
			array_npc[npcProche].can_interact = false
			var label = array_npc[npcProche].get_node("Label")
			label.visible = false
		
	allDistancePlayer.clear()
		

#récupère la plus petite distance avec un npc
func get_distance_mini(allDistancePlayer):
	distanceMini = allDistancePlayer[0]
	npcProche = 0
	for i in range(allDistancePlayer.size()):
		if distanceMini > allDistancePlayer[i]:
			distanceMini = allDistancePlayer[i]
			npcProche = i
