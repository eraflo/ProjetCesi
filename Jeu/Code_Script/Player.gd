extends KinematicBody

#détecter le sol
const _floor = Vector3(0, 1, 0)
const MAX_SLOPE_ANGLE = 40

# mouvement joueur
var velocity = Vector3()
var speed = 50
const walk = 50
const gravity = -24.8
const jump = 18
const sprint = 150



#rotation caméra
var min_elevation_angle = -90
var max_elevation_angle = 90
var rotation_speed = 15
onready var elevation = $Camera

#gestion souris pour rotation
var allow_rotation = true
var _last_mouse_position = Vector2()
var _is_rotating = false

#gestion vue
var perso1 = Vector3(0, 0.742, 0)
var perso3 = Vector3(0, 1.928, 8.502)
var change = false



func _ready():
	pass 



func _physics_process(delta):
	#gravité
	velocity.y += gravity * delta
	
	#déplacement
	_move(delta)
	
	#rotation
	_rotate(delta)
	
	#vue
	vue_perso(delta)
	
	#jump
	_jump(delta)
	
	move_and_slide(velocity, _floor, 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))


#déplacement
func _move(_delta: float):
	speed = walk
	#mouvement (avancer, reculer, droite, gauche)
	if Input.is_action_pressed("sprint"):
		speed = sprint
	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		velocity.x = 0
	elif Input.is_action_pressed("ui_right"):
		velocity += transform.basis.x * speed * _delta
	elif Input.is_action_pressed("ui_left"):
		velocity -= transform.basis.x * speed * _delta
	else:
		velocity.x = lerp(velocity.x, 0, 0.05)
	
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down"):
		velocity.z = 0
	elif Input.is_action_pressed("ui_up"):
		velocity -= transform.basis.z * speed * _delta
	elif Input.is_action_pressed("ui_down"):
		velocity += transform.basis.z * speed * _delta
	else:
		velocity.z = lerp(velocity.z, 0, 0.05)
	
	velocity.normalized()

#gère la rotation
func _rotate(_delta: float) -> void:
	if not _is_rotating or not allow_rotation:
		return
	var displacement = _get_mouse_displacement()
	#rotation droite gauche
	_rotate_left_right(_delta, displacement.x)
	#rotation haut bas
	_elevate(_delta, displacement.y)
	


#récupère la position de la souris
func _get_mouse_displacement() -> Vector2:
	var current_mouse_position = get_viewport().get_mouse_position()
	var displacement = current_mouse_position - _last_mouse_position
	_last_mouse_position = current_mouse_position
	return displacement

#gère la valeur de la rotation de la caméra
func _rotate_left_right(_delta: float, val: float) -> void:
	rotation_degrees.y -= val * _delta * rotation_speed

#regarde si on appuie sur click gauche pour tourner la caméra
func _unhandled_input(event: InputEvent) -> void:
	#test si on tourne la caméra
	if event.is_action_pressed("camera_rotate"):
		_is_rotating = true
		_last_mouse_position = get_viewport().get_mouse_position()
	if event.is_action_released("camera_rotate"):
		_is_rotating = false

#rotation haut bas
func _elevate(_delta: float, val: float) -> void:
	var new_elevation = elevation.rotation_degrees.x - val * _delta * rotation_speed
	new_elevation = clamp(new_elevation, -max_elevation_angle, -min_elevation_angle)
	elevation.rotation_degrees.x = new_elevation

#jump
func _jump(_delta: float):
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity += transform.basis.y * jump 


#changer de vue
func vue_perso(_delta: float):
	if Input.is_action_just_pressed("change_view") and change == false:
		$Camera.translation = perso3
		change = true
	elif Input.is_action_just_pressed("change_view") and change == true:
		$Camera.translation = perso1
		change = false
	
		
	

