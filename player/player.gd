class_name Player
extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 16
@onready var states = $state_manager
@onready var debug_state_label = $debug_state_label

func _ready() -> void:
	$Networking/MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	$Camera2d.current = is_local_authority()
	$Networking.sync_position = position
	states.init(self)
	$Networking.sync_state_path = states.current_state.get_path()
	
func _unhandled_input(event: InputEvent) -> void:
	if is_local_authority():
		states.input(event)
	
func _physics_process(delta: float) -> void:
	debug_state_label.text = states.current_state_name()
	if not is_local_authority():
		states.change_state(get_node($Networking.sync_state_path))
		position = $Networking.sync_position
		return
		
	states.physics_process(delta)
	$Networking.sync_position = position
	$Networking.sync_state_path = states.current_state.get_path()
	

func is_local_authority() -> bool:
	return $Networking/MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()
