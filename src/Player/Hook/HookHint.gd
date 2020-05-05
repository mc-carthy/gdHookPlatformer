tool
extends Node2D

export var colour: Color

func _ready() -> void:
	set_as_toplevel(true)
	update()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 10.0, colour)
