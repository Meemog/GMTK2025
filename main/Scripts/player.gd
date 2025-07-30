extends Area2D

@export var speed = 400

var mouse_location

func _ready() -> void:
	$BodySprite.play()

func _process(delta: float) -> void:
	
	# Movement
	
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$BodySprite.animation = "walk"
		if velocity.x > 0:
			$BodySprite.scale.x = abs($BodySprite.scale.x)
		elif velocity.x < 0:
			$BodySprite.scale.x = abs($BodySprite.scale.x) * -1
	else:
		$BodySprite.animation = "idle"
	
	position += velocity * delta
	
	# Gun
	
	mouse_location = get_viewport().get_mouse_position()
	$GunSprite.rotation = atan2(mouse_location.y - position.y, mouse_location.x - position.x)
