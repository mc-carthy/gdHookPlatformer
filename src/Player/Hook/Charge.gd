extends State

const START_POWER: float = 1.0

export var max_power: float = 3.0

var _power = START_POWER

func enter(msg: Dictionary = {}) -> void:
	_power = START_POWER

func exit() -> void:
	owner.arrow.head.modulate = Color.white

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released('hook'):
		if owner.can_hook():
			_state_machine.transition_to('Aim/Fire', { velocity_multiplier = _power})
		else:
			_state_machine.transition_to('Aim')

func physics_process(delta: float) -> void:
	_power = clamp(_power + delta, START_POWER, max_power)
	var power_percent = (_power - START_POWER) / (max_power - START_POWER)
	var colour_target = Color.blue
	colour_target.a = power_percent
	owner.arrow.head.modulate = Color.white.blend(colour_target)
	
	var move = get_parent()
	move.physics_process(delta)
