extends Node

onready var player: Node2D = $Player

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('debug_spawn'):
		player.state_machine.transition_to('Die')
