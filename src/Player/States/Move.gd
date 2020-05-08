extends State

# Parent state that abstracts and handles basic movement
# Move-related children states can delegate movement to it, or use its utility functions

export var max_velocity_default: Vector2 = Vector2(500.0, 1500.0)
export var acceleration_default: Vector2 = Vector2(100000.0, 3000.0)
export var decceleration_default: Vector2 = Vector2(500.0, 3000.0)

var max_velocity: Vector2 = max_velocity_default
var acceleration: Vector2 = acceleration_default
var decceleration: Vector2 = decceleration_default
var velocity: Vector2 = Vector2.ZERO
var dash_count: int = 0

func _on_hooked_onto_target(target_global_position: Vector2) -> void:
	var to_target = target_global_position - owner.global_position
	if owner.is_on_floor() and to_target.y > 0.0:
		return
	_state_machine.transition_to('Hook', { target_global_position = target_global_position, velocity = velocity })

func _unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed('jump'):
		_state_machine.transition_to('Move/Air', { impulse = true })

func physics_process(delta: float) -> void:
	velocity = calculate_velocity(velocity, max_velocity, acceleration, decceleration, delta, get_move_direction())
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)

func enter(msg: Dictionary = {}) -> void:
	owner.hook.connect('hooked_onto_target', self, '_on_hooked_onto_target')

func exit() -> void:
	owner.hook.disconnect('hooked_onto_target', self, '_on_hooked_onto_target')

static func calculate_velocity(
	old_velocity: Vector2,
	max_velocity: Vector2,
	acceleration: Vector2,
	decceleration: Vector2,
	delta: float,
	move_direction: Vector2
) -> Vector2:
	
	var new_velocity: Vector2 = old_velocity
	new_velocity.y += move_direction.y * acceleration.y * delta
	if move_direction.x:
		new_velocity.x += move_direction.x * acceleration.x * delta
	elif abs(new_velocity.x) > 0.1:
		new_velocity.x -= decceleration.x * delta * sign(new_velocity.x)
		if sign(new_velocity.x) != sign(old_velocity.x):
			new_velocity.x = 0
		
	new_velocity.x = clamp(new_velocity.x, -max_velocity.x, max_velocity.x)
	new_velocity.y = clamp(new_velocity.y, -max_velocity.y, max_velocity.y)
	
	return new_velocity

static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength('move_right') - Input.get_action_strength("move_left"),
		1.0
	)
