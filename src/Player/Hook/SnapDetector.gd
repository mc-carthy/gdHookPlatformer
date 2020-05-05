extends Area2D

onready var hooking_hint: Position2D = $HookHint
onready var ray_cast: RayCast2D = $RayCast2D

var target: HookTarget setget set_target

func has_target() -> bool:
	return target != null

func set_target(value: HookTarget) -> void:
	target = value
	hooking_hint.visible = has_target()
	hooking_hint.global_position = target.global_position if target else global_position
