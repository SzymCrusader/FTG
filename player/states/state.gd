class_name State
extends Node

var player: Player

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func transition(old: State, new: State) -> void:
	pass
	
func input(event: InputEvent) -> State:
	return null
	
func process(delta: float) -> State:
	return null
	
func physics_process(delta: float) -> State:
	return null
