class_name BaseState
extends Node

@export var animation_name: String

var player: Player

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func transition(old: BaseState, new: BaseState) -> void:
	pass
	
func input(event: InputEvent) -> BaseState:
	return null
	
func process(delta: float) -> BaseState:	
	return null
	
func physics_process(delta: float) -> BaseState:
	return null