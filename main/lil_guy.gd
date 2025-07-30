extends Area2D

@export var speed = 200
var screen_size

func _ready():
    screen_size = get_viewport_rect().size
    hide()

func _process(delta: float) -> void:
    var velocity = Vector2.ZERO
    velocity.x += 1
    
    position += velocity * delta * speed

func start(pos):
    position = pos
    show()
