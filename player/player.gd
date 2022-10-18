class_name Player
extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 4

@onready var states = $state_manager
@onready var debug_state_label = $debug_state_label

func _ready() -> void:
	states.init(self)
	
func _unhandled_input(event: InputEvent) -> void:
	states.input(event)
	
func _physics_process(delta: float) -> void:
	debug_state_label.text = states.current_state_name()
	states.physics_process(delta)
