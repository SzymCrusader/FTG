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
	
	print("place - ", get_multiplayer_authority(), " - ", multiplayer.get_unique_id(), " - ", map_pos)
	if  tiles.get_cell_source_id(0, map_pos) != block_id:
		tiles.set_cell(0, map_pos, block_id, Vector2i(0, 0))

@rpc(any_peer, call_local)
func remove(map_pos: Vector2i) -> void:
	tiles.set_cell(0, map_pos, 0, Vector2i(0, 0))
