extends Control

@export var PlayerScene = preload("res://player/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_environment("USERNAME"):
		$PlayerName.text = OS.get_environment("USERNAME")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_pressed():
	start_network(true)
	pass # Replace with function body.


func _on_join_pressed():
	start_network(false)
	pass # Replace with function body.

func start_network(server: bool) -> void:
	var peer = ENetMultiplayerPeer.new()
	if server:
		multiplayer.peer_connected.connect(self.create_player)
		multiplayer.peer_disconnected.connect(self.destroy_player)
		
		peer.create_server(8080)
		print("Server listening on localhost:8080")
		
	else:
		peer.create_client("localhost", 8080)
	multiplayer.set_multiplayer_peer(peer)
		
func create_player(id: int) -> void:
	var player = PlayerScene.instantiate()
	player.name = str(id)
	
	$"../Players".add_child(player)

func destroy_player(id: int) -> void:
	$"../Players".get_node(str(id)).queue_free()
