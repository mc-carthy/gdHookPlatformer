extends State

func _on_cooldown_timeout() -> void:
	_state_machine.transition_to('Aim')

func enter(msg: Dictionary = {}) -> void:
	owner.cooldown.connect('timeout', self, '_on_cooldown_timeout')
	owner.slowdown = false
	owner.cooldown.start()
	var target: HookTarget = owner.snap_detector.target
	owner.arrow.hook_position = target.global_position
	target.hooked_from(owner.global_position)
	owner.emit_signal(
		'hooked_onto_target', 
		target.global_position, 
		msg.velocity_multiplier if msg.has('velocity_multiplier') else 1.0
	)

func exit() -> void:
	owner.cooldown.disconnect('timeout', self, '_on_cooldown_timeout')
