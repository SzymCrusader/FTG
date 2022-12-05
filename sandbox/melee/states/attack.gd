extends State

@export var attack_time: float = 0.15
@export var damage: int = 1

@export var idle_node: NodePath
@onready var idle_state: State = get_node(idle_node)

@export var slash_node: NodePath
@onready var slash: Node = get_node(slash_node)

@export var last_direction_node: NodePath
@onready var last_direction: Node = get_node(last_direction_node)

var attack_timer: float = 0.0

enum direction {
	UP, DOWN, LEFT, RIGHT, NONE
}

func enter():
	super.enter()
	attack_timer = attack_time
	slash.visible = true
	
	var attack_direction
	var input_vertical: int = Input.get_action_strength("player_up") - Input.get_action_strength("player_down")
	var input_horizontal: int = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	
	if input_vertical != 0:
		if input_vertical > 0:
			attack_direction = direction.UP
			last_direction.vertical  = direction.UP
		elif input_vertical < 0:
			attack_direction = direction.DOWN
			last_direction.vertical = direction.DOWN
			
		if input_horizontal > 0:
			last_direction.horizontal = direction.RIGHT
		elif input_horizontal < 0:
			last_direction.horizontal = direction.LEFT
			
	elif input_horizontal != 0:
		if input_horizontal > 0:
			attack_direction = direction.RIGHT
			last_direction.horizontal = direction.RIGHT
		elif input_horizontal < 0:
			attack_direction = direction.LEFT
			last_direction.horizontal = direction.LEFT
	
	else:
		attack_direction = direction.NONE
		last_direction.vertical = direction.NONE
#	
	if attack_direction == direction.NONE:
		attack_direction = last_direction.horizontal

	slash.scale.x = 1
	slash.scale.y = 1
	match attack_direction:
		direction.UP:
			slash.rotation = -PI/2
			flip_sprite(input_horizontal, 1)
		direction.DOWN:
			slash.rotation = PI/2
			flip_sprite(input_horizontal, -1)
		direction.LEFT:
			slash.rotation = 0
			slash.scale.x = -1
		direction.RIGHT:
			slash.rotation = 0
	
	Events.emit_signal("player_attacked", damage)
	for body in $"../..".get_overlapping_bodies():
		if body.has_method("damage"):
			body.damage(damage)

func physics_process(delta: float) -> State:
	attack_timer -= delta
	if attack_timer < 0:
		return idle_state
	return null

# up and down need to be flipped differently for correct result
func flip_sprite(input_horizontal: int, scale: int) -> void:
	if input_horizontal != 0:
		slash.scale.y = -scale if input_horizontal >= 0 else scale
	else:
		match last_direction.horizontal:
			direction.RIGHT:
				slash.scale.y = -scale
			direction.LEFT:
				slash.scale.y = scale
			
