#tool
extends Area2D
#class_name SnapDetector

onready var hooking_hint: Position2D = $HookHint
onready var ray_cast: RayCast2D = $RayCast2D

var target: HookTarget setget set_target

func _ready() -> void:
	ray_cast.set_as_toplevel(true)

func _physics_process(delta: float) -> void:
	self.target = find_best_target()

func find_best_target() -> HookTarget:
	force_update_transform()
	var targets = get_overlapping_areas()
	
	if not targets:
		return null
	
	var closest_target: HookTarget = null
	var closest_target_distance: float = INF
	for target in targets:
		if not target.is_active:
			continue
		
		var dist: float = global_position.distance_to(target.global_position)
		if dist > closest_target_distance:
			continue

		
		ray_cast.global_position = global_position
		ray_cast.cast_to = target.global_position - ray_cast.global_position
		ray_cast.force_raycast_update()
		if ray_cast.is_colliding():
			continue
		closest_target_distance = dist
		closest_target = target

	return closest_target

func has_target() -> bool:
	return target != null

func calculate_length() -> float:
	var length: float = -1.0
	
	for collider in [$AreaH, $AreaV]:
		if not collider:
			continue
		var capsule: CapsuleShape2D = collider.shape
		var max_capsule_length: float = collider.position.length() + capsule.height / 2 * sin(collider.rotation) + capsule.radius
		length = max(length, max_capsule_length)
	
	return length

func set_target(value: HookTarget) -> void:
	target = value
	if hooking_hint:
		hooking_hint.visible = has_target()
		hooking_hint.global_position = target.global_position if target else global_position
