class_name Player
extends CharacterBody2D

@onready var original_color = vision_renderer.color if vision_renderer else Color.WHITE
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var point_light: PointLight2D = $PointLight2D

@export var speed = 100
@export var friction := 20
@export var vision_renderer: Polygon2D
@export var alert_color: Color

signal sanity_changed(new_value: float)

var sanity: float: set = set_sanity, get = get_sanity
var last_direction := Vector2.DOWN  # Começa olhando para baixo

func _ready():
	sanity = 100

func _on_vision_cone_area_body_entered(body: Node2D) -> void:
	print("%s is seeing %s" % [self, body])
	vision_renderer.color = alert_color

func _on_vision_cone_area_body_exited(_body: Node2D) -> void:
	# print("%s stopped seeing %s" % [self, body])
	vision_renderer.color = original_color

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		DialogueManager.show_example_dialogue_balloon(load('res://dialogue/testDialogue.dialogue'), 'start')
		return

func _process(delta: float) -> void:
	set_sanity(sanity - delta)

func _physics_process(_delta: float) -> void:
	var direction := Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	$Sprite2D.flip_h = false
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
		last_direction = direction
		# Animações de movimento
		if direction == Vector2.UP:
			animation_player.play("walk_up")
		elif direction == Vector2.DOWN:
			animation_player.play("walk_down")
		elif direction == Vector2.LEFT:
			animation_player.play("walk_left_down")
		elif direction == Vector2.RIGHT:
			$Sprite2D.flip_h = true
			animation_player.play("walk_right_down")
		elif direction.normalized() == (Vector2.LEFT + Vector2.UP).normalized():
			animation_player.play("walk_left_up")
		elif direction.normalized() == (Vector2.LEFT + Vector2.DOWN).normalized():
			animation_player.play("walk_left_down")
		elif direction.normalized() == (Vector2.RIGHT + Vector2.UP).normalized():
			animation_player.play("walk_right_up")
		elif direction.normalized() == (Vector2.RIGHT + Vector2.DOWN).normalized():
			$Sprite2D.flip_h = true
			animation_player.play("walk_right_down")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction)
		# Animações idle
		if last_direction == Vector2.UP:
			animation_player.play("idle_up")
		elif last_direction == Vector2.DOWN:
			animation_player.play("idle_down")
		elif last_direction == Vector2.LEFT:
			animation_player.play("idle_left_down")
		elif last_direction == Vector2.RIGHT:
			$Sprite2D.flip_h = true
			animation_player.play("idle_right_down")
		elif last_direction.normalized() == (Vector2.LEFT + Vector2.UP).normalized():
			animation_player.play("idle_left_up")
		elif last_direction.normalized() == (Vector2.LEFT + Vector2.DOWN).normalized():
			animation_player.play("idle_left_down")
		elif last_direction.normalized() == (Vector2.RIGHT + Vector2.UP).normalized():
			animation_player.play("idle_right_up")
		elif last_direction.normalized() == (Vector2.RIGHT + Vector2.DOWN).normalized():
			$Sprite2D.flip_h = true
			animation_player.play("idle_right_down")
	# Sempre atualize a lanterna com base na última direção válida
	var offset_distance := 210
	point_light.rotation = last_direction.angle() - PI/2
	point_light.position = last_direction.normalized() * offset_distance
	move_and_slide()

func set_sanity(value: float) -> void:
	sanity = clamp(value, 0, 100)
	emit_signal("sanity_changed", sanity)

func get_sanity() -> float:
	return sanity
