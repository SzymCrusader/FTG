extends CharacterBody2D

var wasonfloor = true

@onready var APEX_BONUS = 0.0
@export var SPEED = 300.0
@export var JUMP_FORCE = 300
@export var MAX_JUMP_FORCE = 500
@onready var JUMP_BUFFER = $JumpBuffer
@onready var COYOTE = $CoyoteTime
@export var MAX_JUMP = 9000
@onready var JUMP_DISTANCE = 0
var JUMP_END = false
@onready var APEX_TIMER = $ApexTimer
var IS_APEX = false
@export var GRAVITY_MODIFIER = 4
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * GRAVITY_MODIFIER

var jump_ended_early = false
var jump_ended = false
@export var jumping = false
@onready var _fall_speed = 2
@export var jump_ended_early_gravity_modifier = 2
@export var max_fall_speed = 4

@onready var smp = get_node("StateMachinePlayer")

var walk_direction = 0



func __physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_just_pressed("player_up"): 
			jumping = true
			smp.set_trigger("jump")
			JUMP_BUFFER.start()
			
		if Input.is_action_just_released("player_up"):
			smp.set_trigger("falling")
			if velocity.y<0:
				
				jump_ended_early = true
				JUMP_END = true
				print("early end")
			
		if JUMP_DISTANCE >=MAX_JUMP:
			JUMP_END = true
			APEX_BONUS = 75.0
			if not IS_APEX:
				APEX_TIMER.start()
				IS_APEX = true
				velocity.y = 0
				
		if Input.is_action_pressed("player_up") and JUMP_DISTANCE<=MAX_JUMP and not JUMP_END and not IS_APEX:
			JUMP_DISTANCE += JUMP_FORCE
			velocity.y = JUMP_FORCE * (-1)
			if JUMP_FORCE < MAX_JUMP_FORCE:
				JUMP_FORCE *= 1.5
				
		
		#if APEX_TIMER.time_left<=0:
		calculate_gravity(delta)

	# Handle Jump.

	if (is_on_floor() or COYOTE.time_left>0) and (Input.is_action_just_pressed("player_up") or JUMP_BUFFER.time_left>0):
		IS_APEX = false
		JUMP_END = false
		JUMP_DISTANCE = 0
		JUMP_FORCE = 300
		jump_ended_early = false
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

func calculate_gravity(delta):
	var fall_speed = gravity * jump_ended_early_gravity_modifier if jump_ended_early and velocity.y < 0 else gravity
	if jump_ended_early and velocity.y < 0:
		print(fall_speed)
	velocity.y += fall_speed * delta
	if velocity.y > max_fall_speed: 
		velocity.y = max_fall_speed
	
func _physics_process(delta):
	if Input.is_action_pressed("player_up"):
		JUMP_BUFFER.start()
		smp.set_trigger("jump")
	var direction = Input.get_axis("player_left", "player_right")
	
	smp.set_param("direction", direction)
	smp.set_param("velocity.x", velocity.x)
	smp.set_param("velocity.y", velocity.y)
	
	
func _horizontal_movement(direction):
	velocity.x = direction * (SPEED + APEX_BONUS)
	
	
func _on_state_machine_player_updated(state, delta):
	var direction = smp.get_param("direction")
	_horizontal_movement(direction)
	$StateDebug.text = state
	match state:
		"Idle":
			pass
		"Moving":
			pass
		"Jumping":			
			if JUMP_DISTANCE >= MAX_JUMP:
				smp.set_trigger("fall")
			JUMP_DISTANCE += JUMP_FORCE
			velocity.y = JUMP_FORCE * (-1)
			if JUMP_FORCE < MAX_JUMP_FORCE:
				JUMP_FORCE *= 1.5
			if Input.is_action_just_released("player_up"):
				smp.set_trigger("fall")
				
			if Input.is_action_pressed("player_up") and JUMP_DISTANCE<=MAX_JUMP and not JUMP_END and not IS_APEX:
				JUMP_DISTANCE += JUMP_FORCE
				velocity.y = JUMP_FORCE * (-1)
				if JUMP_FORCE < MAX_JUMP_FORCE:
					JUMP_FORCE *= 1.5
					
			if (is_on_floor() or COYOTE.time_left>0) and (Input.is_action_just_pressed("player_up") or JUMP_BUFFER.time_left>0):
				IS_APEX = false
				JUMP_END = false
				JUMP_DISTANCE = 0
				JUMP_FORCE = 300
				jump_ended_early = false
				velocity.y = JUMP_FORCE * (-1)
		"Falling":
			JUMP_FORCE = 300
			JUMP_DISTANCE = 0
			velocity.y = 750
			
	calculate_gravity(delta)
	move_and_slide()
		


func _on_state_machine_player_transited(from, to):
	print(from, " -> ", to)
	match from:
		"Idle":
			pass
			
	match to:
		"Idle":
			pass
