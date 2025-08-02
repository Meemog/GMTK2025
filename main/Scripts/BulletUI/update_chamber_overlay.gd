class_name UpdateChamberOverlay
extends Control

@export var player : Player
@onready var revolver: Revolver = $Revolver
@onready var bullet_shop: BulletShop = $BulletShop

var is_visable : bool = true
var tween : Tween

var player_alive : bool = true

var fade_seconds : float = 0.2

func _ready() -> void:
    #assert(player)
    Events.chamber_update_completed.connect(_on_chamber_update_completed)
    Events.player_killed.connect(_on_player_killed)
    open_overlay()

func _process(delta: float) -> void:
    pass

func open_overlay() -> void:
    if not player_alive:
        return
    
    if not get_tree().root.is_node_ready():
        await ready
    
    show_overlay()
    bullet_shop.refresh_shop()
    if player:
        revolver.populate(player.bullets)

func close_overlay() -> void:
    hide_overlay()

func hide_overlay() -> void:
    is_visable = false
    if tween:
        tween.kill()
    
    tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_seconds)
    tween.tween_callback(hide)

func show_overlay() -> void:
    is_visable = true
    if tween:
        tween.kill()
    
    #global_position = get_global_mouse_position()
    tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    tween.tween_callback(show)
    tween.tween_property(self, "modulate", Color.WHITE, fade_seconds)

func _on_chamber_update_completed() -> void:
    
    if player:
        player.bullets = revolver.bullets
    
    hide_overlay()

func _on_player_killed() -> void:
    player_alive = false
