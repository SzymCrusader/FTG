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
	$"../../Networking".set_multiplayer_authority(str(player.name).to_int())
	super.enter()
	attack_timer = attack_time
	slash.visible = true
		
	if is_local_authority():		
		var input_vertical = Input.get_action_strength("player_up") - Input.get_action_strength("player_down")
		if input_vertical > 0:
			last_direction.direction = direction.UP
			
		elif input_vertical < 0:
			last_direction.direction = direction.DOWN
			
		else:
			last_direction.direction = last_direction.horizontal
		$"../../Networking".sync_attack_direction = last_direction.direction
		
	if not is_local_authority():
		last_direction.direction = $"../../Networking".sync_attack_direction
		
	slash.scale.x = 1
	slash.scale.y = 1
	match last_direction.direction:
		direction.UP:
			slash.rotation = -PI/2
			flip_sprite(1)
		direction.DOWN:
			slash.rotation = PI/2
			flip_sprite(-1)
		direction.LEFT:
			slash.rotation = 0
			slash.scale.x = -1
		direction.RIGHT:
			slash.rotation = 0
	
#	if is_local_authority():
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
func flip_sprite(scale: int) -> void:
		match last_direction.horizontal:
			direction.RIGHT:
				slash.scale.y = -scale
			direction.LEFT:
				slash.scale.y = scale
			

func is_local_authority() -> bool:
	return $"../../Networking".get_multiplayer_authority() == multiplayer.get_unique_id()
