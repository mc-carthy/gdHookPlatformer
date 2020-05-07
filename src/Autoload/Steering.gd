extends Node

const DEFAULT_MASS: float = 2.0
const DEFAULT_MAX_SPEED: float = 400.0
const DEFAULT_SLOW_DISTANCE: float = 200.0

static func follow(
	velocity: Vector2,
	global_position: Vector2,
	target_position: Vector2,
	max_speed: float = DEFAULT_MAX_SPEED,
	mass: float = DEFAULT_MASS
) -> Vector2:
	var desired_velocity: Vector2 = Vector2(target_position - global_position).normalized() * max_speed
	var steering: Vector2 = (desired_velocity - velocity) / mass
	return velocity + steering

static func arrive_to(
	velocity: Vector2,
	global_position: Vector2,
	target_position: Vector2,
	max_speed: float = DEFAULT_MAX_SPEED,
	slow_distance: float = DEFAULT_SLOW_DISTANCE,
	mass: float = DEFAULT_MASS
) -> Vector2:
	var distance_to_target: float = global_position.distance_to(target_position)
	var desired_velocity: Vector2 = Vector2(target_position - global_position).normalized() * max_speed
	if distance_to_target < slow_distance:
		desired_velocity *= (distance_to_target / slow_distance) * 0.8 + 0.2
	var steering: Vector2 = (desired_velocity - velocity) / mass
	return velocity + steering
