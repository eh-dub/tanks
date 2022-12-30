extends CharacterBody3D

signal gear_changed(new_gear_name)

var GEARS = [
		{
			"direction": Vector3.BACK,
			"max_speed": 10,
			"name": "Reverse"
		},
		{
			"direction": Vector3.ZERO,
			"max_speed": 0,
			"name": "Neutral"
			
		},
		{
			"direction": Vector3.FORWARD,
			"max_speed": 10,
			"name": "First"
		}
	]

@export var tank_acceleration = 0.5
@export var tank_max_speed = 2

@export var tank_turning_rate = PI / 18

var speed = 0
var gear = 2
func _ready():
	velocity = Vector3.ZERO
	emit_signal("gear_changed", GEARS[gear].name)


func decay_velocity(velocity0, decceleration, delta):
	if velocity0 > 0:
		return max(0, velocity0  - (tank_acceleration * delta) )
	elif velocity0 < 0:
		return min(0, velocity0 + (tank_acceleration * delta))
	else:
		return 0
	
func decay_velocity3(velocity3, delta):
	velocity3 = velocity3 - (velocity3 * 0.1)*delta
	return velocity
	
func _physics_process(delta):
	
	var active_gear = GEARS[gear] 
	var direction = active_gear.direction
	
	if Input.is_action_pressed("turn_left"):
		direction = direction.rotated(Vector3.UP, PI / 18)
	elif Input.is_action_pressed("turn_right"):
		direction = direction.rotated(Vector3.UP, -PI / 18)

	if Input.is_action_pressed("engage_engine"):
		print("engine engaged - accelerating")
		if active_gear.max_speed == 0:
			var decceleration = tank_acceleration * 0.5
			speed = speed - decceleration * delta
		else:
			speed = min(active_gear.max_speed, speed + tank_acceleration * delta)
			
	else:
		var decceleration = tank_acceleration * 0.5
		speed = max(0, speed - decceleration * delta)

		print("engine not engaged - deccelerating")
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	
	if (Input.is_action_just_pressed("shift_gear_down")):
		gear = max(0, gear - 1)
		emit_signal("gear_changed", GEARS[gear].name)
	elif (Input.is_action_just_pressed("shift_gear_up")):
		gear = min(gear + 1, len(GEARS)-1)
		emit_signal("gear_changed", GEARS[gear].name)
	
	print(direction)
	print()
	move_and_slide()
