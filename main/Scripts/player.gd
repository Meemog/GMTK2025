class_name Player
extends RigidBody2D

class TempBullet:
    var damage : float
    var speed : float
    var knockback : float
    var piercing : bool
    var range : float
    var recoil : float
    var additional_status_effect : Array[StatusEffect] = []
    
    func _to_string() -> String:
        return "{Damage: %s, Speed: %s, Knockback: %s, Piercing: %s, Range: %s, Recoil: %s, Status Effects: %s}" % [damage, speed, knockback, piercing, range, recoil, additional_status_effect]


@onready var zoom : Vector2 = get_viewport().get_camera_2d().zoom
@onready var screen_size : Vector2 = get_viewport().size
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var body_sprite: AnimatedSprite2D = $BodySprite
@onready var gun_sprite: AnimatedSprite2D = $GunSprite
@onready var hit_flash_animation_player: AnimationPlayer = $HitFlashAnimationPlayer
@onready var on_hit_particle_scene : PackedScene = preload("res://Scenes/player_on_hit_particle_effect.tscn")
@onready var foot_step_animation_player: AnimationPlayer = $FootStepAnimationPlayer

@export var speed = 400
@export var dash_cooldown = 4
@export var reload_time = 2
@export var firing_cooldown = 0.3
@export var dash_distance = 400
@export var bullet_scene: PackedScene
@export var starting_bullets : Array[Bullet] = []
@export var bullets : Array[Bullet] = []

signal fired()
signal reload()

enum State {MENU, PAUSED, CHAMBERING, LIVE, NULL}

var bullet_pointer : int = 0
var mouse_location
var gun_rotation
var can_dash = true
var can_fire = true
var is_reloading = false
var time_since_shot = firing_cooldown
var time_since_dash = dash_cooldown
var time_since_reload = reload_time
var active = true
var bullet_temp_bonuses : Array[Array] = [[],[],[],[],[],[]]
var collision_damage = 22
var invincibility_time = 1.0
var current_invincibility_time = 0.0

# Player stats
var health : int = 3

func _ready() -> void:
    $BodySprite.play()
    screen_size = screen_size / zoom
    reset()

func _process(delta: float) -> void:
    if not active:
        return

    if current_invincibility_time > 0:
        current_invincibility_time -= delta

    # Movement
    
    var inp_velocity = Vector2.ZERO
    
    if Input.is_action_pressed("up"):
        inp_velocity.y -= 1
    if Input.is_action_pressed("down"):
        inp_velocity.y += 1
    if Input.is_action_pressed("right"):
        inp_velocity.x += 1
    if Input.is_action_pressed("left"):
        inp_velocity.x -= 1
    
    if inp_velocity.length() > 0:
        inp_velocity = inp_velocity.normalized() * speed
        $BodySprite.animation = "walk"
        foot_step_animation_player.play("foot_step")
        $BodySprite.scale.x = abs($BodySprite.scale.x) * -1 if inp_velocity.x < 0 else abs($BodySprite.scale.x)
        if inp_velocity.x > 0:
            $BodySprite.scale.x = abs($BodySprite.scale.x)
        elif inp_velocity.x < 0:
            $BodySprite.scale.x = abs($BodySprite.scale.x) * -1
    else:
        $BodySprite.animation = "idle"
    
    position += inp_velocity * delta + linear_velocity
    position.x = clamp(position.x, -(screen_size.x)/2, screen_size.x/2)
    position.y = clamp(position.y, -(screen_size.y)/2, screen_size.y/2)
    
    # Gun
    mouse_location = get_global_mouse_position()
    gun_rotation = atan2(mouse_location.y - (position.y + 37), mouse_location.x - position.x)
    $GunSprite.rotation = gun_rotation
    $GunSprite.scale.y = abs($GunSprite.scale.y) * -1 if (gun_rotation > PI/2 or gun_rotation < -PI/2) else abs($GunSprite.scale.y)
    
    if Input.is_action_just_pressed("shoot") and time_since_shot > firing_cooldown and not is_reloading:
        shoot()

    # Dash
    """
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
    """
    
    time_since_shot += delta
    if not can_fire:
        if time_since_shot > firing_cooldown-0.1:
            $Cock.play()
            can_fire = true
    
    if is_reloading:
        time_since_reload += delta
        if time_since_reload >= reload_time:
            is_reloading = false
            reload.emit()

func reset() -> void:
    
    health = 3
    
    bullets = []
    for i in range(len(starting_bullets)):
        bullets.append(starting_bullets[i].duplicate())
    
    global_position = Vector2(0, 0)
    
    collision_shape_2d.disabled = false
    $CollisionShape2D.disabled = false
    gun_sprite.show()
    body_sprite.show()
    
    active = true

func play_footstep_sound_fx() -> void:
    $Footsteps.pitch_scale = randf_range(0.85, 1.15)
    $Footsteps.play()
 
func start_reload():
    bullet_pointer = 0
    time_since_reload = 0
    is_reloading = true

func knockback(magnitude: float):
    var dir = Vector2.ONE.rotated(gun_rotation + (3 * PI)/4)
    linear_velocity += dir * magnitude

func shoot() -> void:
    # get bullet information
    var current_bullet = bullets[bullet_pointer]
    var new_temp_bullet : TempBullet = TempBullet.new()
    new_temp_bullet.speed = current_bullet.speed
    new_temp_bullet.knockback = current_bullet.knockback
    new_temp_bullet.damage = current_bullet.damage
    new_temp_bullet.piercing = current_bullet.piercing
    new_temp_bullet.range = current_bullet.range
    
    # apply temp bonuses
    new_temp_bullet = apply_temp_bonuses(bullet_temp_bonuses[bullet_pointer], new_temp_bullet)
    print(new_temp_bullet._to_string())
    bullet_temp_bonuses[bullet_pointer] = []
    
    # instantiate and fire
    var bullet_vector = Vector2.ONE.rotated(gun_rotation - PI/4)
    var bullet : BulletProjectile = bullet_scene.instantiate()
    bullet.position = $GunSprite/Marker2D.global_position
    bullet.rotation = gun_rotation
    bullet.travel_vector = bullet_vector
    
    # apply information to bullet projectile
    bullet.speed = new_temp_bullet.speed
    bullet.damage = new_temp_bullet.damage
    bullet.range = new_temp_bullet.range
    bullet.knockback = new_temp_bullet.knockback
    bullet.piercing = new_temp_bullet.piercing
    bullets[bullet_pointer].bullet_projectile = bullet
    bullet.data = bullets[bullet_pointer]
    print("This is new_temp_bullet.additional_status_effect: "+str(new_temp_bullet.additional_status_effect))
    bullet.additional_status_effect = new_temp_bullet.additional_status_effect
    add_sibling(bullet)
        
    bullet.shoot(self)
    $Shot.play()
    time_since_shot = 0
    can_fire = false
    fired.emit()
        
    # increment bullet pointer
    bullet_pointer += 1
    if bullet_pointer >= 6:
        start_reload()

func apply_temp_bonuses(bonuses, temp_bullet : TempBullet) -> TempBullet:
    if len(bonuses) == 0:
        return temp_bullet
    
    for i in range(len(bonuses)):
        print(bonuses[i])
        var bonueses_keys = bonuses[i].keys()
        var bonueses_values = bonuses[i].values()
        for j in range(len(bonueses_keys)):
            match bonueses_keys[j]:
                "speed":
                    temp_bullet.speed *= bonueses_values[j]
                "damage":
                    temp_bullet.damage *= bonueses_values[j]
                "piercing":
                    temp_bullet.piercing = bonueses_values[j]
                "knockback":
                    temp_bullet.knockback *= bonueses_values[j]
                "range":
                    temp_bullet.range *= bonueses_values[j]
                "status_effect":
                    temp_bullet.additional_status_effect.append_array(bonueses_values[j])
                _:
                    pass
    
    return temp_bullet

func knockback_all_enemies_effect() -> void:
    var particle_effect : CPUParticles2D = on_hit_particle_scene.instantiate()
    particle_effect.one_shot = true
    add_child(particle_effect)
    await get_tree().create_timer(3.0).timeout
    particle_effect.queue_free()

func take_damage(damage : int) -> void:
    if current_invincibility_time <= 0:
        health -= damage
        Events.player_health_updated.emit(health)
        hit_flash_animation_player.play("hit_flash")
        knockback_all_enemies_effect()
        current_invincibility_time = invincibility_time
        if health <= 0:
            die()
    
func die() -> void:
    Events.player_killed.emit()
    await get_tree().create_timer(0.2).timeout
    collision_shape_2d.disabled = true
    $CollisionShape2D.disabled = true
    gun_sprite.hide()
    body_sprite.hide()
    print("You are dead!!!")

func _on_state_change(state):
    print("Changed State")
    if state == State.LIVE:
        active = true
        $BodySprite.play()
    else:
        active = false
        $BodySprite.stop()
        
    
