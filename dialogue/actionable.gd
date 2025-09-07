extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: 	String = "start"
@export var remove: bool 

func action() -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start, [self])

func on_dialogue_option_selected(option: String) -> void:
	if option == "Descansar" && remove == true:
		get_parent().queue_free()		
