extends Node2D

signal change_state(state: State)

enum State {MENU, PAUSED, CHAMBERING, LIVE, NULL}

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

var state = State.MENU
var prev_state = State.NULL

func set_state(new_state: State):
    state = new_state
    change_state.emit(new_state)

func _on_main_menu_play_btn_clicked() -> void:
    # Turn off menu
    $UiManager/MainMenu.hide()
    
    # Do logic for setting up game
    var player = player_scene.instantiate()
    add_child(player)
    
    var enemy = enemy_scene.instantiate()
    enemy.player = player
    enemy.speed = 200
    enemy.position = Vector2(-400, 400)
    add_child(enemy)
    
    # Set State
    set_state(State.LIVE)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        if state == State.MENU:
            pass
        elif state == State.PAUSED:
            set_state(prev_state)
        else:
            prev_state = state
            set_state(State.PAUSED)
