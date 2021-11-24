extends KinematicBody

const _floor = Vector3.UP
const gravity = 50

var maxHp = 10
var hp = maxHp
var damage

var velocity = Vector3.ZERO
var speed = 5
var rotationSpeed = 10

var distancePlayer
var player

#met les bonnes infos dès le départ
func _ready():
	$Sprite3D/Viewport/Label.text = "life = " + str(hp)
	$Sprite3D/Viewport/Label.visible = false


#fait se déplacer le monstre vers le player + affiche infos
func _physics_process(delta):
	$Sprite3D/Viewport/Label.text = "life = " + str(hp)
	print($Sprite3D/Viewport/Label.text)
	
	velocity.y -= gravity * delta
	
	var isPlayerPresent = get_tree().get_nodes_in_group("player")
	if(isPlayerPresent.size() > 0):
		player = isPlayerPresent[0]
		var x = (player.translation.x - translation.x)
		var y = (player.translation.y - translation.y)
		var z = (player.translation.z - translation.z)
		distancePlayer = sqrt(x*x + y*y + z*z)
		var vecteurPlayer = Vector3(x, y, z)
		
		var move_direction =  Vector3.ZERO
		
		if distancePlayer < 20:
			$Sprite3D/Viewport/Label.visible = true
			move_direction.x = vecteurPlayer.x
			move_direction.z = vecteurPlayer.z
			
			move_direction = move_direction.rotated(_floor, rotation.y).normalized()
		else:
			$Sprite3D/Viewport/Label.visible = false
			
			
			
		velocity.x = move_direction.x * speed
		velocity.z = move_direction.z * speed
	
	move_and_slide(velocity, _floor)
	

