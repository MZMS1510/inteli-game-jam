extends Control

@onready var start_button: Button = $StartButton

@export var next_scene: PackedScene = preload("res://scenes/stages/map.tscn")

func _ready() -> void:
  start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
  get_tree().change_scene_to_packed(next_scene)
