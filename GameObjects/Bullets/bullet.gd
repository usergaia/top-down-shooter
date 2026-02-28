class_name Bullet extends Node2D

const SPEED: int = 600

@onready var life_timer: Timer = $LifeTimer

var direction: Vector2

func _ready() -> void:
	life_timer.timeout.connect(_on_life_timer_timeout)

func _process(delta: float):
	global_position += direction * SPEED * delta

func start(direction: Vector2):
	self.direction = direction
	rotation = direction.angle()
	
func _on_life_timer_timeout():
	# only free bullets on host side to prevent conflicts
	if is_multiplayer_authority():
		queue_free()

func register_collision():
	queue_free()
