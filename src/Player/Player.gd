extends KinematicBody2D
class_name Player

onready var skin: Node2D = $Skin
onready var state_machine: StateMachine = $StateMachine
onready var collider: CollisionShape2D = $CollisionShape2D
onready var hook: Hook = $Hook
onready var ledge_detector: LedgeWallDetector = $LedgeWallDetector
onready var floor_detector: FloorDetector = $FloorDetector

const FLOOR_NORMAL: Vector2 = Vector2.UP

var is_active: bool = true setget set_is_active

func set_is_active(value: bool) -> void:
	is_active = value
	if not collider:
		return
	collider.disabled = not value
	hook.is_active = value
