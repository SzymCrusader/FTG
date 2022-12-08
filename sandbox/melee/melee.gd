extends Area2D

@onready var states = $state_manager
@export var player: Player

func _ready() -> void:
	$Networking/MultiplayerSynchronizer.set_multiplayer_authority(str(player.name).to_int())
	states.init(player)
	$Networking.sync_state_path = states.current_state.get_path()
	
func _unhandled_input(event: InputEvent) -> void:
	if is_local_authority():
		states.input(event)

func _physics_process(delta: float) -> void:
	if not is_local_authority():
		states.change_state(get_node($Networking.sync_state_path))
		return
		
	states.physics_process(delta)
	$Networking.sync_state_path = states.current_state.get_path()

func is_local_authority() -> bool:
	return $Networking/MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()
