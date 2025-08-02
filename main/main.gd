extends Node2D

signal change_state(state: State)

enum State {MENU, PAUSED, CHAMBERING, LIVE, NULL}

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene
@export var spawn_manager_scene: PackedScene
@export var ammo_counter_scene: PackedScene
@export var health_bar_scene : PackedScene
@onready var update_chamber_overlay: UpdateChamberOverlay = $UiManager/UpdateChamberOverlay
@export var enemy_speed = 8

var current_round : int = 1
var state = State.MENU
var prev_state = State.NULL
var player: Player

var ammo_counter : AmmoCounter
var health_bar : HealthBar
var spawn_manager : EnemySpawnManager

func _ready() -> void:
    Events.player_killed.connect(_on_player_killed)
    Events.round_ended.connect(_on_round_ended)
    Events.chamber_update_completed.connect(_on_chamber_update_completed)
    Events.game_restart_requested.connect(_on_game_restart_requested)
    update_chamber_overlay.close_overlay()

func set_state(new_state: State):
    state = new_state
    change_state.emit(new_state)

func _on_main_menu_play_btn_clicked() -> void:
    # Turn off menu
    $UiManager/MainMenu.hide()
    
    start_game()
    
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
            
func start_game() -> void:
    # Do logic for setting up game
    player = player_scene.instantiate()
    change_state.connect(player._on_state_change)
    add_child(player)
    
    update_chamber_overlay.player = player
    
    ammo_counter = ammo_counter_scene.instantiate()
    ammo_counter.player = player
    $UiManager.add_child(ammo_counter)
    $UiManager.move_child(ammo_counter, 0)
    
    health_bar = health_bar_scene.instantiate()
    $UiManager.add_child(health_bar)
    
    spawn_manager = spawn_manager_scene.instantiate()
    spawn_manager.player = player
    add_child(spawn_manager)
    Events.new_round_started.emit(current_round)

func restart_game() -> void:
    spawn_manager.reset()
    
    player.reset()
    
    ammo_counter._on_reload()
    
    health_bar.queue_free()
    health_bar = health_bar_scene.instantiate()
    $UiManager.add_child(health_bar)
    
    $UiManager/UpdateChamberOverlay.player_alive = true
    
    current_round = 1
    
    Events.new_round_started.emit(current_round)
    set_state(State.LIVE)

func _on_round_ended() -> void:
    print("Round Ended!!!")
    update_chamber_overlay.open_overlay()
    set_state(State.CHAMBERING)
    
func _on_game_restart_requested() -> void:
    restart_game()

func _on_chamber_update_completed() -> void:
    current_round += 1
    Events.new_round_started.emit(current_round)
    player.start_reload()
    set_state(State.LIVE)

func _on_player_killed() -> void:
    set_state(State.PAUSED)
