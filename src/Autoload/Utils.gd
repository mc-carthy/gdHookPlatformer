extends Node

static func get_aim_joystick_strength() -> Vector2:
	var deadzone: float = 0.5
	var input_strength: Vector2 = Vector2(
		Input.get_action_strength('aim_right') - Input.get_action_strength('aim_left'),
		Input.get_action_strength('aim_down') - Input.get_action_strength('aim_up')
	)
	return input_strength if input_strength.length() > deadzone else Vector2.ZERO

static func get_aim_joystick_direction() -> Vector2:
	return get_aim_joystick_strength().normalized()
