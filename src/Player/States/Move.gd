extends State

# Parent state that abstracts and handles basic movement
# Move-related children states can delegate movement to it, or use its utility functions

export var max_velocity_default: Vector2 = Vector2(500.0, 1500.0)
export var acceleration_default: Vector2 = Vector2(100000.0, 3000.0)
export var jump_impulse: float = 900.0

var max_velocity: Vector2 = max_velocity_default
var acceleration: Vector2 = acceleration_default
var velocity: Vector2 = Vector2.ZERO

func physics_processs(delta: float) -> void:
	velocity = calculate_velocity(velocity, max_velocity, acceleration, delta, get_move_direction())
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)

static func calculate_velocity(
	old_velocity: Vector2,
	max_velocity: Vector2,
	acceleration: Vector2,
	delta: float,
	move_direction: Vector2
) -> Vector2:
	
	var new_velocity: Vector2 = old_velocity
	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_velocity.x, max_velocity.x)
	new_velocity.y = clamp(new_velocity.y, -max_velocity.y, max_velocity.y)
	
	return new_velocity

static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength('move_right') - Input.get_action_strength("move_left"),
		1.0
	)
