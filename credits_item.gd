extends Area2D

@export_file("end&credits.tscn") var credits_scene_path: String = "res://end&credits.tscn"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player") or body.name == "Player":
		get_tree().change_scene_to_file(credits_scene_path)
