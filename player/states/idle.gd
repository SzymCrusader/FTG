extends BaseState

func input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("player_left") or Input.is_action_just_pressed("player_right"):
		return State.Walk
	elif Input.is_action_just_pressed("player_up"):
		return State.Jump
	return State.Null

func physics_process(delta: float) -> int:
	player.velocity.y += player.gravity
	player.move_and_slide()

	if !player.is_on_floor():
		return State.Fall
	return State.Null
