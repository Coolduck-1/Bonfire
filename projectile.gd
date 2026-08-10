extends CharacterBody2D

var pos : Vector2
var rota : float
var dir : Vector2
var speed = 200
var lifetime = 1.0

func _ready():
	set_as_top_level(true)
	global_position = pos
	global_rotation = rota
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta):
	velocity = dir * speed
	move_and_slide()
