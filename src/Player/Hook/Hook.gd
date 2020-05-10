#tool
extends Position2D

class_name Hook, 'res://assets/icons/icon_hook.svg'

const HOOKABLE_PHYSICS_LAYER: int = 2

onready var raycast: RayCast2D = $RayCast2D
onready var arrow: Node2D = $Arrow
onready var snap_detector: Area2D = $SnapDetector
onready var cooldown: Timer = $Cooldown

signal hooked_onto_target(target_global_position)

var is_active: bool = true setget set_is_active
var slowdown: bool = false setget set_slowdown

func _ready() -> void:
	if Engine.editor_hint:
		update()

func _draw() -> void:
	if not Engine.editor_hint:
		return

	var radius = snap_detector.calculate_length()
	DrawingUtils.draw_circle_outline(self, Vector2.ZERO, radius, Color.lightgreen)

func has_target() -> bool:
	var has_target: bool = snap_detector.has_target()
	if not has_target and raycast.is_colliding():
		var collider: Object = raycast.get_collider()
		has_target = collider.get_collision_layer_bit(HOOKABLE_PHYSICS_LAYER)
	return has_target

func can_hook() -> bool:
	return is_active and has_target() and cooldown.is_stopped()

func get_hook_target_position() -> Vector2:
	return snap_detector.target.global_position if snap_detector.has_target() else raycast.get_collision_point()

func get_hook_target() -> HookTarget:
	return snap_detector.target

func get_aim_direction() -> Vector2:
	var direction: Vector2 = Vector2.ZERO
	match Settings.controls:
		Settings.GAMEPAD:
			direction = Utils.get_aim_joystick_direction()
		Settings.KBD_MOUSE:
			direction = (get_global_mouse_position() - global_position).normalized()
	return direction

func set_is_active(value: bool) -> void:
	is_active = value
	set_process_unhandled_input(value)

func set_slowdown(value: bool) -> void:
	slowdown = value
	Engine.time_scale = 0.05 if slowdown else 1.0
