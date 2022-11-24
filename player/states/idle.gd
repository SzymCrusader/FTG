extends BaseState

@export var jump_node: NodePath
@export var fall_node: NodePath
@export var walk_node: NodePath
@export var run_node: NodePath

@onready var jump_state: BaseState = get_node(jump_node)
@onready var fall_state: BaseState = get_node(fall_node)
@onready var walk_state: BaseState = get_node(walk_node)
@onready var run_state: BaseState = get_node(run_node)

func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("player_left") or Input.is_action_just_pressed("player_right"):
		return walk_state
	elif Input.is_action_just_pressed("player_jump"):
		return jump_state
	return null

func physics_process(delta: float) -> BaseState:
	player.velocity.y += player.gravity
	player.move_and_slide()

	if !player.is_on_floor():
		return fall_state
	return null
