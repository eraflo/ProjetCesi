extends KinematicBody

# mouvement joueur
var velocity = Vector3()
const speed = 5
const gravity = 0.5

#rotation caméra
var min_elevation_angle = 10
var max_elevation_angle = 90
var rotation_speed = 15
onready var elevation = $Camera
#gestion souris pour rotation
var allow_rotation = true
var _last_mouse_position = Vector2()
var _is_rotating = false


func _ready():
	pass 



func _process(delta):
	#rotation
	_rotate(delta)
	#gravité
	velocity.y = - gravity
	
	#mouvement (avancer, reculer, droite, gauche)
	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		velocity.x = 0
	elif Input.is_action_pressed("ui_right"):
		velocity = transform.basis.x
	elif Input.is_action_pressed("ui_left"):
		velocity -= transform.basis.x
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
	
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down"):
		velocity.z = 0
	elif Input.is_action_pressed("ui_up"):
		velocity -= transform.basis.z
	elif Input.is_action_pressed("ui_down"):
		velocity += transform.basis.z
	else:
		velocity.z = lerp(velocity.z, 0, 0.2)
	
	move_and_collide(velocity)

#gère la rotation
func _rotate(delta: float) -> void:
	if not _is_rotating or not allow_rotation:
		return
	var displacement = _get_mouse_displacement()
	#rotation droite gauche
	_rotate_left_right(delta, displacement.x)
	#rotation haut bas
	_elevate(delta, displacement.y)
	


#récupère la position de la souris
func _get_mouse_displacement() -> Vector2:
	var current_mouse_position = get_viewport().get_mouse_position()
	var displacement = current_mouse_position - _last_mouse_position
	_last_mouse_position = current_mouse_position
	return displacement

#gère la valeur de la rotation de la caméra
func _rotate_left_right(delta: float, val: float) -> void:
	rotation_degrees.y -= val * delta * rotation_speed

#regarde si on appuie sur click gauche pour tourner la caméra
func _unhandled_input(event: InputEvent) -> void:
	#test si on tourne la caméra
	if event.is_action_pressed("camera_rotate"):
		_is_rotating = true
		_last_mouse_position = get_viewport().get_mouse_position()
	if event.is_action_released("camera_rotate"):
		_is_rotating = false

#rotation haut bas
func _elevate(delta: float, val: float) -> void:
	var new_elevation = elevation.rotation_degrees.x + val * delta * rotation_speed
	new_elevation = clamp(new_elevation, -max_elevation_angle, -min_elevation_angle)
	elevation.rotation_degrees.x = new_elevation


