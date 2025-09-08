extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
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
	move_and_slide()
