extends Node2D

onready var head: Sprite = $Head
onready var tail: Line2D = $Tail
onready var tween: Tween = $Tween

onready var length: float = tail.points[0].x setget set_length
onready var start_length: float = head.position.x

var hook_position: Vector2 = Vector2.ZERO setget set_hook_position


func set_hook_position(value: Vector2) -> void:
	hook_position = value
	var to_target: Vector2 = hook_position - global_position
	self.length = to_target.length()
	rotation = to_target.angle()
	tween.interpolate_property(
		self,
		'length',
		length,
		start_length,
		0.25,
		Tween.EASE_OUT
	)
	tween.start()

func set_length(value: float) -> void:
	length = value
	tail.points[-1].x = length
	head.position.x = tail.points[-1].x + tail.position.x
