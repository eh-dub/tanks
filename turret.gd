extends CharacterBody3D

@export var turret_angular_speed = PI/16
@export var cannon_angular_speed = PI/18

func _process(delta):
	var turret_angular_velocity = 0;
	
	if Input.is_action_pressed("rotate_turret_anticlockwise"):
		turret_angular_velocity = turret_angular_speed
	elif  Input.is_action_pressed("rotate_turret_clockwise"):
		turret_angular_velocity = -1 * turret_angular_speed
		
	$Pivot.global_rotate(Vector3.UP, turret_angular_velocity*delta)
	
	var cannon_angular_velocity = 0;
	if Input.is_action_pressed("pitch_turret_up"):
		cannon_angular_velocity = cannon_angular_speed
	elif Input.is_action_pressed("pitch_turret_down"):
		cannon_angular_velocity = cannon_angular_speed * -1
		
	get_node("Pivot/CannonPivot").global_rotate(Vector3.RIGHT, cannon_angular_velocity*delta)


