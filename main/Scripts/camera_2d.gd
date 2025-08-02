extends Camera2D

# Screen shake variables:
var shake_intensity : float
var active_shake_time : float
var shake_decay : float = 5.0
var shake_time : float = 0.0
var shake_time_speed : float = 20.0
var noise = FastNoiseLite.new()

# Camera Recoil variable:
var tween : Tween

# Follow Player variables:


func _ready() -> void:
    Events.screen_shake_requested.connect(_on_screen_shake_requested)
    Events.camera_recoil_requested.connect(_on_camera_recoil_requested)

func _physics_process(delta: float) -> void:
    if active_shake_time > 0:
        shake_time += delta * shake_time_speed
        active_shake_time -= delta
        
        offset = Vector2(
            noise.get_noise_2d(shake_time, 0) * shake_intensity,
            noise.get_noise_2d(0, shake_time) * shake_intensity
        )
        
        shake_intensity = max(shake_intensity - shake_decay * delta, 0)
    else:
        offset = lerp(offset, Vector2.ZERO, 10.5 * delta)

func _on_screen_shake_requested(intensity : float, time : float) -> void:
    randomize()
    noise.seed = randi()
    noise.frequency = 2.0
    
    self.shake_intensity = intensity
    self.active_shake_time = time
    shake_time = 0.0

func _on_camera_recoil_requested(intensity: float, direction : Vector2, impluse_time : float, recover_time : float) -> void:
    if tween:
        tween.kill()
    
    print("Screen Recoil!")
    
    var start_position : Vector2 = position
    var final_recoil_position : Vector2 = (position - (direction*intensity)) * PI
    
    tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(self, "position", final_recoil_position, impluse_time)
    await tween.finished
    
    tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(self, "position", start_position, recover_time)
    
