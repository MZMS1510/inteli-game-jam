extends Control


func _on_player_sanity_changed(new_value: float) -> void:
  $SanityBar.value = new_value
