extends State

onready var move:= get_parent()

func unhandled_input(event: InputEvent) -> void:
	move.unhandled_input(event)

func physics_process(delta: float) -> void:
	if owner.is_on_floor():
		if move.get_move_direction().x != 0.0:
			_state_machine.transition_to('Move/Run')
	else:
		_state_machine.transition_to('Move/Air')

func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	move.max_velocity = move.max_velocity_default
	move.velocity = Vector2.ZERO

func exit() -> void:
	move.exit()
