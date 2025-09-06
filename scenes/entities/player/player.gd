class_name Player
extends CharacterBody2D


@export var speed = 100
@export var vision_renderer: Polygon2D
@export var alert_color: Color

signal sanity_changed(new_value: float)

@export var friction := 20
var sanity: float: set = set_sanity, get = get_sanity

func _ready():
	sanity = 100

@onready var original_color = vision_renderer.color if vision_renderer else Color.WHITE

func _on_vision_cone_area_body_entered(body: Node2D) -> void:
	print("%s is seeing %s" % [self, body])
	vision_renderer.color = alert_color

func _on_vision_cone_area_body_exited(body: Node2D) -> void:
	# print("%s stopped seeing %s" % [self, body])
	vision_renderer.color = original_color
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		DialogueManager.show_example_dialogue_balloon(load('res://dialogue/testDialogue.dialogue'), 'start')
		return
		
func _process(delta: float) -> void:
	set_sanity(sanity - delta)

func _physics_process(_delta: float) -> void:
	var direction := Vector2.ZERO
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction)


	move_and_slide()

func set_sanity(value: float) -> void:
	sanity = clamp(value, 0, 100)
	emit_signal("sanity_changed", sanity)

func get_sanity() -> float:
	return sanity
