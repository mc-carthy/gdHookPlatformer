extends Position2D

class_name Hook, 'res://assets/icons/icon_hook.svg'

onready var raycast: RayCast2D = $RayCast2D
onready var arrow: Node2D = $Arrow
onready var snap_detector: Area2D = $SnapDetector
onready var cooldown: Timer = $Cooldown

var is_active: bool = true

func can_hook() -> bool:
	return is_active and snap_detector.has_target() and cooldown.is_stopped()

func get_aim_direction() -> Vector2:
	var direction: Vector2 = Vector2.ZERO
	direction = (get_global_mouse_position() - global_position).normalized()
	return direction
