extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var target_to_chase: CharacterBody2D

const SPEED = 150

func _ready() -> void:

	set_physics_process(false)
	call_deferred("wait_for_physics")
	
func wait_for_physics():
	await get_tree().physics_frame
	set_physics_process(true)
	
func _physics_process(delta: float) -> void: 
	if State.enemyAlive == false && State.enemyHasReturned == false:
		global_position = Vector2(10000, 10000)
		State.enemyHasReturned = true
	if State.enemySpawn == true && State.enemyAlive == false:
		print("Dentro do loop!!!!!!!")
		print(State.spawnX, State.spawnY)
		global_position = Vector2(State.spawnX, State.spawnY)		
		State.enemyAlive = true
		State.enemyHasReturned = false
		State.enemySpawn = false
	if navigation_agent.is_navigation_finished() and target_to_chase.global_position == navigation_agent.target_position: 
		return
	navigation_agent.target_position = target_to_chase.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * SPEED

	animated_sprite.flip_h = velocity.x < 0
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animated_sprite.play("walk_right_down")
			else:
				animated_sprite.play("walk_left_down")
		elif velocity.y < 0:
			animated_sprite.play("walk_up")
		else:
			animated_sprite.play("walk_down")
	else:
		animated_sprite.play("idle_down")

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body is Player:
		get_tree().change_scene_to_file("res://scenes/stages/game_over.tscn")
