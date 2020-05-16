class_name LedgeWallDetector
extends Position2D

onready var ray_top: RayCast2D = $RayTop
onready var ray_bottom: RayCast2D = $RayBottom

export var is_active: bool = true

func _ready() -> void:
	assert(ray_top.cast_to.x > 0)
	assert(ray_bottom.cast_to.x > 0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('move_right'):
		scale.x = 1
	if event.is_action_pressed('move_left'):
		scale.x = -1

func is_against_ledge() -> bool:
	var top_colliding: bool = ray_top.is_colliding()
	var bottom_colliding: bool = ray_bottom.is_colliding()
	if is_active and bottom_colliding:
		return not top_colliding
	return false
	#return is_active and bottom_colliding and not top_colliding

func is_against_wall() -> bool:
	return is_active and (ray_top.is_colliding() or ray_bottom.is_colliding())

func get_cast_to_directed() -> Vector2:
	return ray_top.cast_to * scale

func get_top_globl_position() -> Vector2:
	return ray_top.global_position
