extends MoveState

func input(event: InputEvent) -> BaseState:
	var new_state = super.input(event)
	if new_state:
		return new_state
		
	if Input.is_action_just_pressed("player_run"):
		return run_state
	
	return null
