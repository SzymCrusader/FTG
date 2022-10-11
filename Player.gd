extends CharacterBody2D

var wasonfloor = true

var APEX_BONUS = 0.0
const SPEED = 300.0
var JUMP_FORCE = 300
const MAX_JUMP_FORCE = 500
@onready var JUMP_BUFFER = $JumpBuffer
@onready var COYOTE = $CoyoteTime
const MAX_JUMP = 9000
@onready var JUMP_DISTANCE = 0
var JUMP_END = false
@onready var APEX_TIMER = $ApexTimer
var ISAPEX = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") *1.5
 

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_just_pressed("player_up"): 
			JUMP_BUFFER.start()
		if Input.is_action_just_released("player_up"):
			JUMP_END = true
		if JUMP_DISTANCE >=MAX_JUMP:
			JUMP_END = true
			APEX_BONUS = 75.0
			APEX_TIMER.start()
		if Input.is_action_pressed("player_up") and JUMP_DISTANCE<=MAX_JUMP and not JUMP_END:
			JUMP_DISTANCE += JUMP_FORCE
			velocity.y = JUMP_FORCE * (-1)
			if JUMP_FORCE < MAX_JUMP_FORCE:
				JUMP_FORCE *= 1.5
		velocity.y += gravity * delta

	if APEX_TIMER.time_left<=0 and APEX_BONUS != 0:
		APEX_BONUS = 0

	print(velocity.x)

	# Handle Jump.

	if (is_on_floor() or COYOTE.time_left>0) and (Input.is_action_just_pressed("player_up") or JUMP_BUFFER.time_left>0):
		JUMP_END = false
		JUMP_DISTANCE = 0
		JUMP_FORCE = 300
		velocity.y = JUMP_FORCE * (-1)

		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = direction * (SPEED + APEX_BONUS)

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if wasonfloor == false and is_on_floor():
		wasonfloor = true 
	
	move_and_slide()
	
	if wasonfloor == true and not is_on_floor():
		wasonfloor = false
		COYOTE.start()
