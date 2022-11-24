extends BaseState

@export var jump_force: float = 100
@export var move_speed:float = 60

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	super.enter()
	player.velocity.y = -jump_force

func physics_process(delta: float) -> int:
	var move = 0
	if Input.is_action_pressed("player_left"):
		move = -1
#		player.animations.flip_h = true
	elif Input.is_action_pressed("player_right"):
		move = 1
#		player.animations.flip_h = false
	
	player.velocity.x = move * move_speed
	player.velocity.y += player.gravity
	player.move_and_slide()
	
	if player.velocity.y > 0:
		return State.Fall

	if player.is_on_floor():
		if move != 0:
			return State.Walk
		else:
			return State.Idle
	return State.Null
