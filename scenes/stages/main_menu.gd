extends Control

@onready var start_button: Button = $StartButton
@onready var music: AudioStreamPlayer = $AudioStreamPlayer

@export var next_scene: PackedScene = preload("res://scenes/stages/map.tscn")

func _ready() -> void:
  start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed() -> void:
  var music_tween := create_tween()
  # var background_tween := create_tween()

  music_tween.tween_property(music, "volume_db", -80, 1).as_relative()
  # background_tween.tween_property(self, "modulate:a", 0.0, 0.5).as_relative()
  music_tween.finished.connect(_change_to_next_scene)


func _change_to_next_scene() -> void:
  get_tree().change_scene_to_packed(next_scene)
