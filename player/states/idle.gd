extends State

@export var jump_node: NodePath
@export var fall_node: NodePath
@export var walk_node: NodePath
@export var run_node: NodePath

@onready var jump_state: State = get_node(jump_node)
@onready var fall_state: State = get_node(fall_node)
@onready var walk_state: State = get_node(walk_node)
@onready var run_state: State = get_node(run_node)

func input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("player_jump"):
		return jump_state
	return null

func physics_process(delta: float) -> State:
	if Input.get_action_strength("player_right") - Input.get_action_strength("player_left") != 0:
		return walk_state
	
	player.velocity.y += player.gravity
	player.move_and_slide()

	if !player.is_on_floor():
		return fall_state
	return null
