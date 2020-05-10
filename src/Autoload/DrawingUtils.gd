#tool
extends Node2D

const CIRCLE_POINTS_COUNT: int = 32

static func draw_circle_outline(obj: CanvasItem = null, position: Vector2 = Vector2.ZERO, radius: float = 30.0, colour: Color = Color.magenta, thickness: float = 1.0) -> void:
	var points_array: PoolVector2Array = PoolVector2Array()
	
	for i in range(CIRCLE_POINTS_COUNT + 1):
		var angle: float = 2 * PI * i / CIRCLE_POINTS_COUNT
		var point: Vector2 = position + Vector2(cos(angle * radius), sin(angle * radius))
		points_array.append(point)
	obj.draw_polyline(points_array, colour, thickness, true)
