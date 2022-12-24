class_name Player
extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 16

@onready var states = $state_manager
@onready var debug_state_label = $debug_state_label
@onready var animation_head = $Animation/Head
@onready var animation_body = $Animation/Body
@onready var sprites = $Sprite

func _ready() -> void:
	$Networking/MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	$Camera2d.current = is_local_authority()
	$Networking.sync_position = position
	states.init(self)
	$Networking.sync_state_path = states.current_state.get_path()

func head_animation() -> void:
	var head_direction = "Neutral"
	if not is_local_authority():
		play_head_animation($Networking.sync_head_direction)
		
	if is_local_authority():
		if Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right"):
			if Input.is_action_pressed("player_up"):
				head_direction = "SideUp"
			elif Input.is_action_pressed("player_down"):
				head_direction = "SideDown"
			else:
				head_direction = "Side"
		elif Input.is_action_pressed("player_up"):
			head_direction = "Up"
		elif Input.is_action_pressed("player_down"):
			head_direction = "Down"
		else:
			head_direction = "Neutral"
		$Networking.sync_head_direction = head_direction
		play_head_animation(head_direction)
		
func play_head_animation(head_direction: String) -> void:
	match head_direction:
		"SideUp":
			if animation_head.current_animation != "SideUp":
				animation_head.play("SideUp")
		"SideDown":
			if animation_head.current_animation != "SideDown":
				animation_head.play("SideDown")
				
		"Side":
			if animation_head.current_animation != "Side":
				animation_head.play("Side")
		"Up":
			if animation_head.current_animation != "Up":
				animation_head.play("Up")
				
		"Down":
			if animation_head.current_animation != "Down":
				animation_head.play("Down")
				
		"Neutral":
			if animation_head.current_animation != "Neutral":
				animation_head.play("Neutral")
				
	
func _unhandled_input(event: InputEvent) -> void:
	if is_local_authority():
		states.input(event)
	
func rotation() -> void:
	if velocity.x < 0:
		if sprites.scale.x != -1:
			sprites.scale.x = -1
	else:
		if sprites.scale.x != 1:
			sprites.scale.x  = 1 

func _physics_process(delta: float) -> void:
	head_animation()
	rotation()
	debug_state_label.text = states.current_state_name()
	if not is_local_authority():
		states.change_state(get_node($Networking.sync_state_path))
		position = $Networking.sync_position
		velocity = $Networking.sync_velocity
		return
		
	states.physics_process(delta)
	$Networking.sync_position = position
	$Networking.sync_state_path = states.current_state.get_path()
	$Networking.sync_velocity = velocity
	

func is_local_authority() -> bool:
	return $Networking/MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()
