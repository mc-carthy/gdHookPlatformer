extends State

func _on_cooldown_timeout() -> void:
	_state_machine.transition_to('Aim')

func physics_process(delta: float) -> void:
	get_parent().physics_process(delta)

func enter(msg: Dictionary = {}) -> void:
	owner.cooldown.connect('timeout', self, '_on_cooldown_timeout')
	owner.slowdown = false
	owner.cooldown.start()
	var target: HookTarget = owner.get_hook_target()
	if target:
		owner.arrow.hook_position = target.global_position
		target.hooked_from(owner.global_position)
	else:
		owner.arrow.hook_position = owner.raycast.get_collision_point()

	owner.emit_signal(
		'hooked_onto_target', 
		owner.get_hook_target_position(), 
		msg.velocity_multiplier if msg.has('velocity_multiplier') else 1.0
	)

func exit() -> void:
	owner.cooldown.disconnect('timeout', self, '_on_cooldown_timeout')
