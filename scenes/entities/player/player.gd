class_name Player
extends CharacterBody2D


@onready var original_color = vision_renderer.color if vision_renderer else Color.WHITE
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var point_light: PointLight2D = $PointLight2D
@onready var camera: Camera2D = $Camera2D
@onready var  actionable_finder: Area2D = $ActionableFinder
@onready var enemy_scene = preload("res://scenes/entities/curupira/curupira.tscn")
@onready var step_sound = preload("res://assets/sounds/step.ogg")

@export var speed = 100
@export var friction := 20
@export var vision_renderer: Polygon2D
@export var visionConeArea: Area2D
@export var alert_color: Color
@export var camera_limit_left: Marker2D
@export var camera_limit_right: Marker2D

signal sanity_changed(new_value: float)

var sanity: float: set = set_sanity, get = get_sanity
var step_sound_player: AudioStreamPlayer2D

func _ready():
	sanity = 100
	
	step_sound_player = AudioStreamPlayer2D.new()
	step_sound.loop = true
	step_sound_player.stream = step_sound
	add_child(step_sound_player)

	var offset_distance := 180
	point_light.rotation = Vector2.DOWN.angle() - PI/2
	point_light.position = Vector2.DOWN.normalized() * offset_distance
	call_deferred("_setup_camera_limits")

func _setup_camera_limits():
	if camera_limit_left and camera_limit_right:
		camera.limit_left = floor(camera_limit_left.position.x)
		camera.limit_right = floor(camera_limit_right.position.x)
		camera.limit_top = floor(camera_limit_right.position.y)
		camera.limit_bottom = floor(camera_limit_left.position.y)
	else:
		print("Algum marker está nulo!")

func _on_vision_cone_area_body_entered(body: Node2D) -> void:
	print("%s is seeing %s" % [self, body])
	if body.name == "Curupira":
		print("BIZARRO")
		State.enemyAlive = false
		
	vision_renderer.color = alert_color

func _on_vision_cone_area_body_exited(_body: Node2D) -> void:
	# print("%s stopped seeing %s" % [self, body])
	vision_renderer.color = original_color

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return
		
func _process(delta: float) -> void:
	if State.sanityToUpdate == true:
		sanity = sanity + 20
		State.sanityToUpdate = false
	set_sanity(sanity - delta)

func _physics_process(_delta: float) -> void:		
	var direction := Vector2.ZERO
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))

	# Jeito mais porco possível de mudar a animação
	# Usar blend spaces ou algo do tipo seria mais elegante
	$Sprite2D.flip_h = false
	if direction == Vector2.ZERO:
		step_sound_player.stop()
		match animation_player.current_animation:
			"walk_down":
				animation_player.play("idle_down")
			"walk_up":
				animation_player.play("idle_up")
			"walk_left_down":
				animation_player.play("idle_left_down")
			"walk_left_up":
				animation_player.play("idle_left_up")
			"walk_right_down":
				animation_player.play("idle_right_down")
			"walk_right_up":
				animation_player.play("idle_right_up")
			_:
				animation_player.play(animation_player.current_animation)
	elif direction == Vector2.UP:
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

	if direction != Vector2.ZERO:
		if not step_sound_player.playing:
			step_sound_player.play()
		direction = direction.normalized()
		var offset_distance := 180
		point_light.rotation = direction.angle() - PI/2
		point_light.position = direction.normalized() * offset_distance


		if vision_renderer:
			vision_renderer.rotation = direction.angle() 
			vision_renderer.position = direction.normalized() 
		if visionConeArea:
			visionConeArea.rotation = direction.angle()
			visionConeArea.position = direction.normalized()
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction)

	move_and_slide()

func set_sanity(value: float) -> void:
	sanity = clamp(value, 0, 100)
	emit_signal("sanity_changed", sanity)

func get_sanity() -> float:
	return sanity
