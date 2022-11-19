extends BaseState

@export var move_speed: float = 60

@export var idle_node: NodePath
@export var walk_node: NodePath

@onready var idle_state: BaseState = get_node(idle_node)
@onready var walk_state: BaseState = get_node(walk_node)

func physics_process(delta: float) -> BaseState:
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

	if player.is_on_floor():
		if move != 0:
			return walk_state
		else:
			return idle_state
	return null
