extends Node

signal tooltip_requested(bullet : Bullet)
signal hide_tooltop_requested()

signal chamber_update_completed()

signal new_round_started(round_num : int)
signal round_ended()

signal enemy_died()
signal player_health_updated(player_health : int)
