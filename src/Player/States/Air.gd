extends State

export var acceleration_x: float = 5000.0
export var jump_impulse: float = 900.0
export var max_jumps: int = 2
var current_jumps: int = 0

func jump():
	var move:= get_parent()
	current_jumps += 1
	move.velocity.y = 0
	move.velocity += calculate_jump_velocity(jump_impulse)

func unhandled_input(event: InputEvent) -> void:
	var move = get_parent()
	if move.dash_count == 0 and event.is_action_pressed('dash'):
		move.dash_count += 1
		_state_machine.transition_to('Move/Dash', { direction = owner.hook.raycast.cast_to.normalized()})
		return
	if event.is_action_pressed('jump') and current_jumps <= max_jumps:
		jump()
	move.unhandled_input(event)

func physics_process(delta: float) -> void:
	var move:= get_parent()
	move.physics_process(delta)
	
	if owner.is_on_floor():
		move.dash_count = 0
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
		move.max_velocity.x = max(abs(msg.velocity.x), move.max_velocity.x)
	if 'impulse' in msg:
		jump()

func exit() -> void:
	current_jumps = 0
	var move:= get_parent()
	move.acceleration = move.acceleration_default
	move.exit()

func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	var move:= get_parent()
	return move.calculate_velocity(
		move.velocity,
		move.max_velocity,
		Vector2(0, impulse),
		Vector2.ZERO,
		1.0,
		Vector2.UP
	)
