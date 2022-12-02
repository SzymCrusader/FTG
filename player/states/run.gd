extends MoveState

func input(event: InputEvent) -> State:
	var new_state = super.input(event)
	if new_state:
		return new_state
		
	if Input.is_action_just_released("player_run"):
		return walk_state
	
	return null
