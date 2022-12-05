extends State

@export var attack_node: NodePath
@onready var attack_state: State = get_node(attack_node)

@export var slash_node: NodePath
@onready var slash: Node = get_node(slash_node)

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
	return null
