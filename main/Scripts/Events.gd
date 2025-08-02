extends Node

signal tooltip_requested(bullet : Bullet)
signal hide_tooltop_requested()

signal chamber_update_completed()

signal new_round_started(round_num : int)
signal round_ended()

signal enemy_died()
signal player_health_updated(player_health : int)

signal player_killed()
signal game_restart_requested()
signal screen_shake_requested(intensity : float, time : float)
signal camera_recoil_requested(intensity: float, direction : Vector2, impluse_time : float, recover_time : float)
