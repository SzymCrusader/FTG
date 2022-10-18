extends Node

# from https://github.dev/theshaggydev/the-shaggy-dev-projects

@onready var states = {
	BaseState.State.Idle: $idle,
	BaseState.State.Walk: $walk,
	BaseState.State.Fall: $fall,
	BaseState.State.Jump: $jump,
}

var current_state: BaseState
var current_state_index: int

func change_state(new_state: int) -> void:
	if current_state:
		current_state.exit()

	current_state = states[new_state]
	current_state_index = new_state
	current_state.enter()
	
# Initialize the state machine by giving each state a reference to the objects
# owned by the parent that they should be able to take control of
# and set a default state
func init(player: Player) -> void:
	for child in get_children():
		child.player = player

	# Initialize with a default state of idle
	change_state(BaseState.State.Idle)
	
# Pass through functions for the Player to call,
# handling state changes as needed
func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state != BaseState.State.Null:
		change_state(new_state)

func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state != BaseState.State.Null:
		change_state(new_state)

func current_state_name() -> String:
	return BaseState.State.keys()[current_state_index]
