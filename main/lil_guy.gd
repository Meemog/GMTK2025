extends Area2D

@export var speed = 200
var screen_size
var start_pos

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	velocity.x += 1
	
	position += velocity * delta * speed
	
	if (position.x > screen_size.x + 60):
		position = start_pos

func start(pos):
	start_pos = pos
	position = pos
	show()
