class_name MoveState
extends State

@export var move_speed: float = 60

@export var idle_node: NodePath
@export var jump_node: NodePath
@export var fall_node: NodePath
@export var walk_node: NodePath
@export var run_node: NodePath

@onready var idle_state: State = get_node(idle_node)
@onready var jump_state: State = get_node(jump_node)
@onready var fall_state: State = get_node(fall_node)
@onready var walk_state: State = get_node(walk_node)
@onready var run_state: State = get_node(run_node)

func input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("player_jump"):
		return jump_state
	return null
	
func physics_process(delta: float) -> State:
	if !player.is_on_floor():
		return fall_state

	var move = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")

	player.velocity.y += player.gravity
	player.velocity.x = move * move_speed
	player.move_and_slide()
	
	if move == 0 or player.velocity.x == 0:
		return idle_state

	return null
