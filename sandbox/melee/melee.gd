extends Area2D

@onready var states = $state_manager
@export var player: Player

func _ready() -> void:
	states.init(player)
	
func _unhandled_input(event: InputEvent) -> void:
	states.input(event)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
