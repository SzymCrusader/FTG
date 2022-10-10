extends CharacterBody2D

var wasonfloor = true

const SPEED = 300.0
const JUMP_FORCE = 500
@onready var JUMP_BUFFER = $JumpBuffer
@onready var COYOTE = $CoyoteTime
const MAX_JUMP = 10000
@onready var JUMP_DISTANCE = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
 

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		print(JUMP_DISTANCE)
		if Input.is_action_pressed("player_up") and JUMP_DISTANCE<=MAX_JUMP:
			JUMP_DISTANCE += JUMP_FORCE
			velocity.y = JUMP_FORCE * (-1)
		velocity.y += gravity * delta

	# Handle Jump.

	if (is_on_floor() or COYOTE.time_left>0) and (Input.is_action_just_pressed("player_up") or JUMP_BUFFER.time_left>0):
		JUMP_DISTANCE = 0
		velocity.y = JUMP_FORCE * (-1)

		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if wasonfloor == false and is_on_floor():
		wasonfloor = true 
	
	move_and_slide()
	
	if wasonfloor == true and not is_on_floor():
		wasonfloor = false
		COYOTE.start()
