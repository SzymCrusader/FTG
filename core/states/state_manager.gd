extends Node

# from https://github.dev/theshaggydev/the-shaggy-dev-projects

@export var starting_state: NodePath

@export var animation_node: NodePath
@onready var animation: AnimationPlayer = get_node(animation_node)

@export var current_state: State

func change_state(new_state: State) -> void:
	var old_state = current_state
	if current_state:
		current_state.exit()	
	
	current_state = new_state
	if old_state:
		current_state.transition(old_state, new_state)
	animation.play(new_state.name)
	current_state.enter()
	
# Initialize the state machine by giving each state a reference to the objects
# owned by the parent that they should be able to take control of
# and set a default state
func init(player: Player) -> void:
	for child in get_children():	
		child.player = player
		
		# nested states also need player variable
		for child2 in child.get_children():
			child2.player = player

	change_state(get_node(starting_state))
	
# Pass through functions for the Player to call,
# handling state changes as needed
func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)

func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)

func current_state_name() -> String:
	return current_state.name as String

func get_current_state() -> State:
	return current_state

func is_local_authority() -> bool:
	return get_multiplayer_authority() == multiplayer.get_unique_id()
