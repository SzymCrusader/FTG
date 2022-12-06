extends State

@export var attack_node: NodePath
@onready var attack_state: State = get_node(attack_node)

@export var slash_node: NodePath
@onready var slash: Node = get_node(slash_node)

@export var last_direction_node: NodePath
@onready var last_direction: Node = get_node(last_direction_node)

enum direction {
	UP, DOWN, LEFT, RIGHT
}

func enter() -> void:
	super.enter()
	slash.visible = false
	
func input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("player_attack"):		
		return attack_state
	return null

func physics_process(delta: float) -> State:	
	set_attack_direction()
	return null

func set_attack_direction() -> void:
	var input_horizontal = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")

	var direction_horizontal: direction
		
	if input_horizontal > 0:
		direction_horizontal = direction.RIGHT
		
	elif input_horizontal < 0:
		direction_horizontal = direction.LEFT
	
	if input_horizontal != 0:
		last_direction.horizontal = direction_horizontal
