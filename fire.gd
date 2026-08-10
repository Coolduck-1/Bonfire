extends CharacterBody2D

var bullet_path = preload("res://projectile.tscn")

func _process(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		fire()

func _physics_process(delta):
	pass
	

#makes fire go whoosh
func fire():
	var bullet = bullet_path.instantiate()
	bullet.dir = ($Node2D.global_position.direction_to(get_global_mouse_position()))
	bullet.pos = $Node2D.global_position
	bullet.rota = global_rotation
	get_parent().add_child(bullet)
