extends Node2D

@onready var tiles = get_tree().get_root().get_node("level/TileMap")

func _ready():
	name = str(get_multiplayer_authority())

func _unhandled_input(event):
	var map_pos: Vector2i = tiles.local_to_map(get_global_mouse_position())
	if Input.is_action_pressed("player_place"):
		rpc("place", 1, map_pos)
	if Input.is_action_pressed("player_remove"):
		rpc("remove", map_pos)

@rpc(any_peer, call_local)
func place(block_id: int, map_pos) -> void:
	if  tiles.get_cell_source_id(0, map_pos) != block_id:
		tiles.set_cells_terrain_connect(0, [map_pos], 0, block_id)

@rpc(any_peer, call_local)
func remove(map_pos: Vector2i) -> void:
	tiles.set_cells_terrain_connect(0, [map_pos], 0, -1)
