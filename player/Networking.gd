extends Node

@export var sync_position: Vector2
# NodePath instead of Node and it's derivatives
# because NetworkSynchronizer doesn't play nice with Nodes
@export var sync_state_path: NodePath
@export var sync_state_name: String
@export var sync_head_direction: String
@export var sync_velocity: Vector2
