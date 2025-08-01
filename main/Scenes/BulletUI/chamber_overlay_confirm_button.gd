extends Button

func _on_pressed() -> void:
    Events.chamber_update_completed.emit()
