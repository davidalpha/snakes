extends KinematicBody


var segment = load("res://segment.tscn")
var deltasum = 0.0
# Can't fly below this speed
var min_flight_speed = 10
# Maximum airspeed
var max_flight_speed = 35
# Turn rate
var turn_speed = 0.75
# Climb/dive rate
var pitch_speed = 0.5
# Lerp speed returning wings to level
var level_speed = 1.0
# Throttle change speed
var throttle_delta = 30
# Acceleration/deceleration
var acceleration = 12.0

# Current speed
var forward_speed = 10.0
# Throttle input speed
var target_speed = 10
# Lets us change behavior when grounded
var scale_factor = 0.5

var velocity = Vector3.ZERO
var turn_input = 0
var pitch_input = 0
var dead = false


func _physics_process(delta):
		
	get_input(delta)
	# Rotate the transform based on the input values
	transform.basis = transform.basis.rotated(transform.basis.x.normalized(), pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(Vector3.UP, turn_input * turn_speed * delta)

	# Roll the body based on the turn input
	$body.transform.basis = Basis()
	$body.scale = Vector3(scale_factor, scale_factor, scale_factor)
	$body.transform.basis = $body.transform.basis.orthonormalized()
	var target_angle = $body.transform.basis.rotated((-$body.transform.basis.z * forward_speed).normalized(), turn_input*-1.5)
	if not dead:
		$body.transform.basis = Basis($body.transform.basis.slerp(target_angle, .4))
	
	# Accelerate/decelerate
	forward_speed = lerp(forward_speed, target_speed, acceleration * delta)
	# Movement is always forward
	velocity = -transform.basis.z * forward_speed
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	var world = get_node("/root/main")
	var seg_inst = segment.instance()
	deltasum += delta
	if deltasum > 0.5:
		seg_inst.transform = global_transform
		world.add_child(seg_inst)
		deltasum = 0.0
		
	
func get_input(delta):
	# Throttle input
	if Input.is_action_pressed("throttle_up"):
		target_speed = min(forward_speed + throttle_delta * delta, max_flight_speed)
	if Input.is_action_pressed("throttle_down"):
		target_speed = max(forward_speed - throttle_delta * delta, min_flight_speed)
	# Turn (roll/yaw) input
	turn_input = 0
	if forward_speed > 0.5:
		turn_input -= Input.get_action_strength("roll_right")
		turn_input += Input.get_action_strength("roll_left")
	# Pitch (climb/dive) input
	pitch_input = 0
	pitch_input -= Input.get_action_strength("pitch_down")
	pitch_input += Input.get_action_strength("pitch_up")

