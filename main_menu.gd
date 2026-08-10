extends Control

@onready var mainbuttons: VBoxContainer = $Mainbuttons
@onready var options: Panel = $Options



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _ready():
	mainbuttons.visible = true
	options.visible = false

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_options_pressed() -> void:
	print("options")
	options.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_exit_options_pressed() -> void:
	options.visible = false
