extends CharacterBody2D

@export var speed = 100

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		DialogueManager.show_example_dialogue_balloon(load('res://dialogue/testDialogue.dialogue'), 'start')
		return
		
func _physics_process(_delta: float) -> void:
	var direction := Vector2.ZERO
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 20)
	
	move_and_slide()
