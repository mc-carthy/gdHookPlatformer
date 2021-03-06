extends State

signal jumped

onready var coyote_timer: Timer = $CoyoteTimer
onready var freeze_control_timer: Timer = $FreezeControls

export var acceleration_x: float = 5000.0
export var max_jumps: int = 3

var current_jumps: int = 0

func jump(impulse):
	var move:= get_parent()
	current_jumps += 1
	move.velocity.y = 0
	move.velocity += calculate_jump_velocity(impulse)

func unhandled_input(event: InputEvent) -> void:
	var move = get_parent()
	if event.is_action_pressed('jump'):
		emit_signal('jumped')
		if current_jumps < max_jumps:
			jump(move.jump_impulse)
		elif move.velocity.y >= 0.0 and coyote_timer.time_left > 0.0:
			jump(move.jump_impulse)

	if move.dash_count == 0 and event.is_action_pressed('dash'):
		move.dash_count += 1
		_state_machine.transition_to('Move/Dash', { direction = owner.hook.raycast.cast_to.normalized()})
		return
	move.unhandled_input(event)

func physics_process(delta: float) -> void:
	var move:= get_parent()
	#move.physics_process(delta)
	var direction: Vector2 = move.get_move_direction() if freeze_control_timer.is_stopped() else Vector2(sign(move.velocity.x), 1.0)
	move.velocity = move.calculate_velocity(move.velocity, move.max_velocity, move.acceleration, move.decceleration, delta, direction)
	move.velocity = owner.move_and_slide(move.velocity, owner.FLOOR_NORMAL)
	
	if owner.is_on_floor():
		move.dash_count = 0
		if move.get_move_direction().x == 0.0:
			_state_machine.transition_to('Move/Idle')
		else:
			_state_machine.transition_to('Move/Run')
	elif owner.ledge_detector.is_against_ledge():
		_state_machine.transition_to('Ledge', { move_state = move })
	
	if owner.is_on_wall():
		var wall_normal: float = owner.get_slide_collision(0).normal.x
		_state_machine.transition_to('Move/Wall', { wall_normal = wall_normal, velocity = move.velocity})

func enter(msg: Dictionary = {}) -> void:
	var move:= get_parent()
	move.enter(msg)
	move.acceleration.x = acceleration_x
	
	if 'velocity' in msg:
		move.velocity = msg.velocity
		move.max_velocity.x = max(abs(msg.velocity.x), move.max_velocity.x)
	if 'impulse' in msg:
		jump(msg.impulse)
	if 'wall_jump' in msg:
		freeze_control_timer.start()
		move.max_velocity.x = max(move.max_velocity_default.x, abs(move.velocity.x))
	coyote_timer.start()

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
