extends State

export var acceleration_x: float = 5000.0

func unhandled_input(event: InputEvent) -> void:
	get_parent().unhandled_input(event)

func physics_process(delta: float) -> void:
	var move:= get_parent()
	move.physics_process(delta)
	
	if owner.is_on_floor():
		if move.get_move_direction().x == 0.0:
			_state_machine.transition_to('Move/Idle')
		else:
			_state_machine.transition_to('Move/Run')

func enter(msg: Dictionary = {}) -> void:
	var move:= get_parent()
	move.enter(msg)
	move.acceleration.x = acceleration_x
	
	if 'velocity' in msg:
		move.velocity = msg.velocity
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed.x)
	if 'impulse' in msg:
		move.velocity += calculate_jump_velocity(msg.impulse)

func exit() -> void:
	var move:= get_parent()
	move.acceleration = move.acceleration_default
	move.exit()

func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	var move:= get_parent()
	return move.calculate_velocity(
		move.velocity,
		move.max_velocity,
		Vector2(0, impulse),
		1.0,
		Vector2.UP
	)
