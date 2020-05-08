extends State

func _on_skin_animation_finished(anim_name: String) -> void:
	_state_machine.transition_to('Spawn')

func enter(msg: Dictionary = {}) -> void:
	owner.is_active = false
	owner.hook.visible = false
	#owner.camera_rig.is_active = false
	owner.skin.play('die')
	owner.skin.connect('animation_finished', self, '_on_skin_animation_finished')

func exit() -> void:
	owner.skin.disconnect('animation_finished', self, '_on_skin_animation_finished')
