extends State

onready var timer: Timer = $Timer

export var dash_speed: float = 1500.0

var direction: Vector2 = Vector2.ZERO
var _velocity: Vector2 = Vector2.ZERO

func _on_timer_timeout() -> void:
	_state_machine.transition_to('Move/Air', { velocity = _velocity })

func enter(msg: Dictionary = {}) -> void:
	timer.connect('timeout', self, '_on_timer_timeout', [], CONNECT_ONESHOT)
	direction = msg.direction
	timer.start()

func physics_process(delta: float) -> void:
	_velocity = owner.move_and_slide(direction * dash_speed, owner.FLOOR_NORMAL)
	Events.emit_signal('player_moved', owner)
