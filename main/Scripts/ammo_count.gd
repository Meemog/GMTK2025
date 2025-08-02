class_name AmmoCounter
extends Control

var player: Player

@onready var barrels: Array[Sprite2D] = [$Barrel/Chamber1, $Barrel/Chamber2, $Barrel/Chamber3, $Barrel/Chamber4, $Barrel/Chamber5, $Barrel/Chamber6]

var tween : Tween

func _ready() -> void:
    fill_bullets()

    player.fired.connect(_on_fired)
    player.reload.connect(_on_reload)
    
func fill_bullets():
    
    for i in range(6):
        barrels[i].texture = player.bullets[i].back_view_texture
        

func _on_fired():
    barrels[player.bullet_pointer].texture = null
    
    if tween:
        tween.kill()
    
    tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property($Barrel, "rotation", $Barrel.rotation-(PI/3), player.firing_cooldown/2)
    
    #$Barrel.rotation -= PI/3

func _on_reload():
    fill_bullets()
    $Barrel.rotation = 0
    
