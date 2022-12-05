extends Node

@export var health: int = 2

signal health_depleted

func damage(damage: int) -> void:
	print("damaged: ", damage, " - ", self)
	health -= damage
	if health <= 0:
		emit_signal("health_depleted")
