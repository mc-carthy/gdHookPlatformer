extends State

export var max_speed_sprint: float = 900.0

func unhandled_input(event: InputEvent) -> void:
	var move:= get_parent()
	move.unhandled_input(event)

func physics_process(delta: float) -> void:
	var move:= get_parent()
	if owner.is_on_floor() and move.velocity.length() < 1.0:
		_state_machine.transition_to('Move/Idle')
	else:
		_state_machine.transition_to('Move/Air')
	
	if Input.is_action_pressed("sprint"):
		move.max_velocity.x = max_speed_sprint
	else:
		move.max_velocity.x = move.max_velocity_default.x
	move.physics_process(delta)

func enter(msg: Dictionary = {}) -> void:
	get_parent().enter(msg)

func exit() -> void:
	get_parent().exit()
