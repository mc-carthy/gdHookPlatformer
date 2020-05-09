extends State

func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('slowdown'):
		owner.slowdown = not owner.slowdown
	if event.is_action_pressed('hook') and owner.can_hook():
		_state_machine.transition_to('Aim/Charge')

func physics_process(delta: float) -> void:
	var cast: Vector2 = owner.get_aim_direction() * owner.raycast.length
	var angle: float = cast.angle()
	owner.raycast.cast_to = cast
	owner.arrow.rotation = angle
	owner.snap_detector.rotation = angle
	owner.raycast.force_raycast_update()
