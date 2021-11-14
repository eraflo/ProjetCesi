extends KinematicBody
signal change(value)

#détecter le sol
const _floor = Vector3.UP
const MAX_SLOPE_ANGLE = 40

# mouvement joueur
var velocity = Vector3.ZERO
var _snap_vector = Vector3.DOWN
var speed
onready var _model = $"."
const walk = 7.0
const gravity = 50
const jump = 20
const sprint = 14.0

#Caractéristiques perso
export var life = 200
export var money = 0
export var strengh = 10


#rotation caméra
var min_elevation_angle = -90
var max_elevation_angle = 20
var rotation_speed = 15
onready var elevation = $SpringArm2
onready var _spring_arm = $SpringArm

#gestion souris pour rotation
var allow_rotation = true
var _last_mouse_position = Vector2()
var _is_rotating = false

#gestion vue
export var change = false


func _ready():
	emit_signal("change", false)
	#positionnement la joueur là où il se trouvait à la dernière sauvegarde
	translation.x = GameManager.player_x
	translation.y = GameManager.player_y
	translation.z = GameManager.player_z
	

func _process(delta):
	_spring_arm.translation = Vector3(translation.x, translation.y + 1.5, translation.z)
	elevation.rotation_degrees = _spring_arm.rotation_degrees
	

func _physics_process(delta):
	#gravité
	velocity.y -= gravity * delta
		
	#déplacement
	_move(delta)
	
	#rotation
	if change == false:
		_rotate(delta)
	
	#jump
	_jump(delta)
	
	#vue
	vue_perso()

	velocity = move_and_slide_with_snap(velocity, _snap_vector, _floor, true)
	
	#Update la position à save
	GameManager.player_x = translation.x
	GameManager.player_y = translation.y
	GameManager.player_z = translation.z


#déplacement
func _move(_delta: float):
	
	speed = walk
	#mouvement (avancer, reculer, droite, gauche)
	if Input.is_action_pressed("sprint"):
		speed = sprint
	
	var move_direction = Vector3.ZERO
	
	move_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_direction.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if change == true:
		move_direction = move_direction.rotated(_floor, _spring_arm.rotation.y).normalized()
	else:
		move_direction = move_direction.rotated(_floor, $SpringArm2.rotation.y).normalized()
	
	velocity.x = move_direction.x * speed
	velocity.z = move_direction.z * speed
	
	if change == true:
		if velocity.length() > 0.2:
			var look_direction = Vector2(velocity.z, velocity.x)
			_model.rotation.y = look_direction.angle()
	

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
func _rotate_left_right(_delta: float, val: float) :
	$SpringArm2.rotation_degrees.y -= val * _delta * rotation_speed
	$SpringArm.rotation_degrees.y -= val * _delta * rotation_speed
	
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
	_spring_arm.rotation_degrees.x = new_elevation


#jump
func _jump(_delta: float):
	var just_landed = is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping = is_on_floor() and Input.is_action_just_pressed("jump")
	if is_jumping:
		velocity.y = jump
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN


#changer de vue
func vue_perso():
	if Input.is_action_just_pressed("change_view") and change == false:
		emit_signal("change", true)
		$SpringArm2/Camera2.current = false
		$SpringArm/Camera.current = true
		change = true
	elif Input.is_action_just_pressed("change_view") and change == true:
		emit_signal("change", false)
		$SpringArm/Camera.current = false
		$SpringArm2/Camera2.current = true
		change = false
	


