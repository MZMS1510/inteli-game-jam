extends CharacterBody2D

@export var vision_renderer: Polygon2D
@export var alert_color: Color

func _on_vision_cone_area_body_entered(body: Node2D) -> void:
	print("%s is seeing %s" % [self, body])
	vision_renderer.color = alert_color
