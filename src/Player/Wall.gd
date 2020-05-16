extends State

export var slide_acceleration: float = 1600.0
export var max_slide_speed: float = 400.0
export(float, 0.0, 1.0) var friction_factor: float = 0.15

var _wall_normal: float
var _velocity: Vector2

func physics_process(delta: float) -> void:
	#_velocity.y = clamp(_velocity.y, -max_slide_speed, max_slide_speed)
	if _velocity.y > max_slide_speed:
		_velocity.y = lerp(_velocity.y, max_slide_speed, friction_factor)
	elif _velocity.y < -max_slide_speed:
		_velocity.y = max(_velocity.y, -max_slide_speed)
	else:
		_velocity.y += slide_acceleration * delta
	_velocity = owner.move_and_slide(_velocity, owner.FLOOR_NORMAL)
	
	if owner.is_on_floor():
		_state_machine.transition_to('Move/Idle')
	
	var move = get_parent()
	var is_moving_away_from_wall: bool = sign(move.get_move_direction().x) == sign(_wall_normal)
	
	if is_moving_away_from_wall or not owner.ledge_detector.is_against_wall():
		_state_machine.transition_to('Move/Air', { velocity = _velocity })

func enter(msg: Dictionary = {}) -> void:
	var move = get_parent()
	move.enter(msg)
	
	_wall_normal = msg.wall_normal
	_velocity.y = msg.velocity.y

func exit() -> void:
	get_parent().exit()
