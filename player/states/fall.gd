extends BaseState

@export var move_speed: float = 60
@export var fall_gravity_multiplier: float = 4
@export var jump_buffer_time: float = 0.1
@export var coyote_time: float = 0.2

@export var idle_node: NodePath
@export var walk_node: NodePath
@export var jump_node: NodePath

@onready var idle_state: BaseState = get_node(idle_node)
@onready var walk_state: BaseState = get_node(walk_node)
@onready var jump_state: BaseState = get_node(jump_node)

var jump_buffer_timer: float = 0.0 
var coyote_timer:float = 0.0

func enter() -> void:
		super.enter()
		jump_buffer_timer = 0
		
func transition(old: BaseState, new: BaseState) -> void:
	super.transition(old, new)
	if old != jump_state:
		coyote_timer = coyote_time
	else:
		coyote_timer = 0

func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("player_jump"):
		jump_buffer_timer = jump_buffer_time
		if coyote_timer > 0:
			return jump_state
		
	return null

func physics_process(delta: float) -> BaseState:
	jump_buffer_timer -= delta
	coyote_timer -= delta
#	print(coyote_timer)
	
	var move = 0
	if Input.is_action_pressed("player_left"):
		move = -1
#		player.animations.flip_h = true
	elif Input.is_action_pressed("player_right"):
		move = 1
#		player.animations.flip_h = false
	
	player.velocity.x = move * move_speed
	player.velocity.y += player.gravity * fall_gravity_multiplier
	player.move_and_slide()

	if player.is_on_floor():
		if jump_buffer_timer > 0:
			print("jump")
			return jump_state
		if move != 0:
			return walk_state
		else:
			return idle_state
	return null
