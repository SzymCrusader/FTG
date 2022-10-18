extends Node2D

@onready var tiles = get_tree().get_root().get_node("level/TileMap")

func _unhandled_input(event):
		if Input.is_action_pressed("player_place"):
			place(1)
		if Input.is_action_pressed("player_remove"):
			remove()

func place(block_id: int) -> void:
	var map_pos = tiles.local_to_map(get_global_mouse_position())
	if  tiles.get_cell_source_id(0,map_pos) != block_id:
		print("place")
		tiles.set_cell(0, map_pos, block_id, Vector2i(0, 0))

func remove() -> void:
	var map_pos = tiles.local_to_map(get_global_mouse_position())
	tiles.set_cell(0, map_pos, 0, Vector2i(0, 0))
