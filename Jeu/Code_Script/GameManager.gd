extends Node

var game_data : Dictionary

var autosave_length : int = 5
var autosave_on = false
var autosave_start_time = 0

var playing = false #si true, on lance le cooldown de l'autosave
var first_load = false

var player_x = 0
var player_y = 10
var player_z = 23
var cam_x = 0
var cam_y = -90
var cam_z = 0

#change valeur sauvegarder, on update avant de save
func update_data():
	game_data = {"player_data" :
		{
			"posx" : player_x,
			"posy" : player_y,
			"posz" : player_z,
			"camx" : cam_x,
			"camy" : cam_y,
			"camz" : cam_z,
		},
	"options" : 
		{
			"autosave" : autosave_length
		}
		
		
	}

#sauvegarde
func do_save():
	update_data()
	#nouveau fichier
	var file : File = File.new()
	#en crée un nouveau si n'existe pas
	file.open("res://game_data/game.dat", File.WRITE)
	#stock dictionnaire en json
	file.store_line(to_json(game_data))
	file.close() #ferme le fichier

#charger
func do_load() -> bool:
	var file : File = File.new() #new file
	if(file.file_exists("res://game_data/game.dat")): #regarde si file existe
		file.open("res://game_data/game.dat", File.READ) #open file
		
		game_data = parse_json(file.get_as_text()) #transforme le json en dictionnaire
		
		file.close() #ferme file
		
		#charge les attributs
		var option_data = game_data["options"]
		var player_data = game_data["player_data"]
		#charge les options
		autosave_length = option_data["autosave"]
		#Charge données du player
		GameManager.player_x = player_data["posx"]
		GameManager.player_y = player_data["posy"]
		GameManager.player_z = player_data["posz"]
		GameManager.cam_x = player_data["camx"]
		GameManager.cam_y = player_data["camy"]
		GameManager.cam_z = player_data["camz"]
		
		
		return true
	
	else:
		return false

func _physics_process(delta):
	if(playing):
		autosave_logic()

func autosave_logic():
	#enlève temps de départ du temps actuel (avoir en secondes)
	var time_passed = OS.get_unix_time() - autosave_start_time
	#regarde si dépassé le cooldown de l'autosave (exemple : save toutes les 60s)
	if(time_passed > (autosave_length * 1)):
		#on save
		do_save()
		
		#on reset le cooldown
		autosave_start_time = OS.get_unix_time()



















