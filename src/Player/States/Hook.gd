extends State

export var hook_max_speed: float = 1500.0
export var arrive_push: float = 1500.0

var target_global_position: Vector2 = Vector2(INF, INF)
var velocity: Vector2 = Vector2.ZERO
var velocity_multiplier: float = 1.0

func physics_process(delta: float) -> void:
	velocity = Steering.arrive_to(
		velocity, 
		owner.global_position,
		target_global_position,
		hook_max_speed * velocity_multiplier
	)
	velocity = velocity if velocity.length() > arrive_push else velocity.normalized() * arrive_push * velocity_multiplier
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	Events.emit_signal('player_moved', owner)
	
	var to_target: Vector2 = target_global_position - owner.global_position
	var distance = to_target.length()
	
	if distance < velocity.length():
		velocity = velocity.normalized() * arrive_push  * velocity_multiplier
		_state_machine.transition_to('Move/Air', { velocity = velocity })

func enter(msg: Dictionary = {}) -> void:
	match msg:
		{ 'target_global_position': var tgp, 'velocity': var v, 'velocity_multiplier': var vm}:
			target_global_position = tgp
			velocity = v
			velocity_multiplier = vm
		

func exit() -> void:
	target_global_position = Vector2(INF, INF)
	velocity = Vector2.ZERO
