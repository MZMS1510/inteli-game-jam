extends Control

@export var next_scene: PackedScene = preload("res://scenes/stages/main_menu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		get_tree().change_scene_to_packed(next_scene)
