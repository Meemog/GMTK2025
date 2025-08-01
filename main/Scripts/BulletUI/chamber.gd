class_name Chamber
extends Area2D

signal new_bullet_inserted(chamber : Chamber, bullet : Bullet)

var current_bullet : BulletUI = null
var bullet_manager : Node2D = null

func _ready() -> void:
    # Needs to be a Node with the group "BULLET_UI_MANAGER" for Chamber not to throw error
    bullet_manager = get_tree().get_nodes_in_group("BULLET_UI_MANAGER")[0]

func clear_chamber() -> void:
    current_bullet = null
    for child in get_children():
        if child is BulletUI:
            child.queue_free()

func insert_bullet(bullet : BulletUI) -> void:
    # This works but holy shit it is dirty!!! Oscar fixed :3
    if current_bullet:
        if bullet.chambered:
            current_bullet.return_position = bullet.return_position
            current_bullet.chambered = true
            current_bullet.chamber = bullet.chamber
            bullet.chamber.current_bullet = current_bullet
        else:
            current_bullet.switch_view(true)
            current_bullet.return_position = bullet.return_position
            current_bullet.reparent(bullet_manager)
    else:
        if bullet.chambered:
            bullet.chamber.current_bullet = null
    bullet.reparent(self)
    bullet.return_position = self.global_position
    bullet.chambered = true
    bullet.chamber = self
    bullet.switch_view(false)
    current_bullet = bullet
    if current_bullet:
        if bullet.chambered:
            current_bullet.reparent(bullet.chamber)
            
    new_bullet_inserted.emit(self, bullet.data)
    
    
