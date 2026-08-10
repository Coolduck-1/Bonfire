extends CharacterBody2D


const SPEED = 75

var direction = 1
var health = 3


#i have no idea it just works
func add_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
#moves the enemy
func move_enemy():
	velocity.x = SPEED * direction
	
#sees if it bumps into a wall
func reverse_direction():
	if is_on_wall():
		direction = -direction

#calls functions
func _physics_process(delta: float) -> void:
	add_gravity(delta)
	move_enemy()
	move_and_slide()
	reverse_direction()
