extends StaticBody2D


func _ready():
	$health.health_depleted.connect(die)

func damage(damage: int) -> void:
	$health.damage(damage)

func die():
	queue_free()
