extends State

func _on_skin_animation_finished(name: String) -> void:
	if name == 'ledge':
		_state_machine.transition_to('Move/Run')

func enter(msg: Dictionary = {}) -> void:
	assert('move_state' in msg and msg.move_state is State)
	
	owner.skin.connect('animation_finished', self, '_on_skin_animation_finished', [], CONNECT_DEFERRED)
	
	var start_pos: Vector2 = owner.global_position
	var ld: LedgeWallDetector = owner.ledge_detector
	owner.global_position = ld.get_top_globl_position() + ld.get_cast_to_directed()
	owner.global_position = owner.floor_detector.get_floor_position()
	msg.move_state.velocity.y = 0.0
	owner.skin.position = start_pos - owner.global_position + Vector2(0, 2)
	owner.skin.play('ledge')

func exit() -> void:
	owner.skin.disconnect('animation_finished', self, '_on_skin_animation_finished')
