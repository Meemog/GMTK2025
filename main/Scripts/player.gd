extends Area2D

@export var speed = 400
@export var dash_cooldown = 4
@export var firing_cooldown = 0.3
@export var dash_distance = 400
@export var bullet_scene: PackedScene

var mouse_location
var gun_rotation
var can_dash = true
var can_fire = true
var time_since_shot = firing_cooldown
var time_since_dash = dash_cooldown

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
        $BodySprite.scale.x = abs($BodySprite.scale.x) * -1 if velocity.x < 0 else abs($BodySprite.scale.x)
        if velocity.x > 0:
            $BodySprite.scale.x = abs($BodySprite.scale.x)
        elif velocity.x < 0:
            $BodySprite.scale.x = abs($BodySprite.scale.x) * -1
    else:
        $BodySprite.animation = "idle"
    
    position += velocity * delta
    
    # Gun
    mouse_location = get_viewport().get_mouse_position()
    gun_rotation = atan2(mouse_location.y - (position.y + 37), mouse_location.x - position.x)
    $GunSprite.rotation = gun_rotation
    $GunSprite.scale.y = abs($GunSprite.scale.y) * -1 if (gun_rotation > PI/2 or gun_rotation < -PI/2) else abs($GunSprite.scale.y)
    
    if Input.is_action_just_pressed("shoot") and time_since_shot > firing_cooldown:
        # get bullet information
        var bullet_speed = 800
        
        # fire
        var bullet_vector = Vector2.ONE.rotated(gun_rotation - PI/4)
        var bullet = bullet_scene.instantiate()
        bullet.position = $GunSprite/Marker2D.global_position
        bullet.rotation = gun_rotation
        bullet.speed = bullet_speed
        bullet.travel_vector = bullet_vector
        add_sibling(bullet)
        $Shot.play()
        time_since_shot = 0
        can_fire = false

    # Dash
    if Input.is_action_just_pressed("dash") and can_dash:
        if velocity != Vector2.ZERO:
            position += (velocity/speed) * dash_distance
        else:
            position.x += dash_distance * abs($BodySprite.scale.x)/$BodySprite.scale.x
            
        $Dash.play()
        time_since_dash = 0
        can_dash = false
    
    
    if not can_dash:
        time_since_dash += delta
        if time_since_dash > dash_cooldown:
            $Recharge.play()
            can_dash = true
    
    time_since_shot += delta
    if not can_fire:
        if time_since_shot > firing_cooldown-0.1:
            $Cock.play()
            can_fire = true
            
