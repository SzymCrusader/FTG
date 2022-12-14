extends State

@export var fall_node: NodePath
@export var walk_node: NodePath
@export var run_node: NodePath
@export var idle_node: NodePath

@onready var fall_state: State = get_node(fall_node)
@onready var walk_state: State = get_node(walk_node)
@onready var run_state: State = get_node(run_node)
@onready var idle_state: State = get_node(idle_node)

@export var jump_force: float = 300 * 2
@export var move_speed:float = 300

func enter() -> void:
	# This calls the base class enter function, which is necessary here
	# to make sure the animation switches
	super.enter()
	player.velocity.y = -jump_force

func physics_process(delta: float) -> State:
	var move = 0
	if Input.is_action_pressed("player_left"):
		move = -1

	elif Input.is_action_pressed("player_right"):
		move = 1

	if Input.is_action_just_released("player_jump") or !Input.is_action_pressed("player_jump"):
		player.velocity.y = 0
	
	player.velocity.x = move * move_speed
	player.velocity.y += player.gravity
	player.move_and_slide()
	
	if player.velocity.y > 0:
		return fall_state

	if player.is_on_floor():
		if move != 0:
			return walk_state
		else:
			return idle_state
	return null
