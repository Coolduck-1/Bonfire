extends CharacterBody2D

const SPEED = 75

@onready var animated_sprite = $AnimatedSprite2D

var direction = 1
var is_dead = false
var health = 2:
	set(new_value):
		if new_value < health:
			print("Playing HIT animation!")
			$AnimatedSprite2D.play("hit")
		health = new_value

#i have no idea
func add_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
#moves the enemy
func move_enemy():
	velocity.x = SPEED * direction
	$AnimatedSprite2D.flip_h = direction > 0

func plataform_edge():
	if not $RayCast.is_colliding():
		direction = -direction
		$RayCast.position.x *= -1

#sees if it bumps into a wall
func reverse_direction():
	if is_on_wall():
		direction = -direction

#calls functions
func _physics_process(delta: float) -> void:
	if health <= 0:
		if not is_dead:
			is_dead = true
			$AnimatedSprite2D.play("death")
			$CollisionShape2D.set_deferred("disabled", true)
			$HurtPlayerZone.set_deferred("disable", true)
			await $AnimatedSprite2D.animation_finished
			queue_free()
		return
	add_gravity(delta)
	move_enemy()
	mushroom_death()
	move_and_slide()
	reverse_direction()
	plataform_edge()
	animate()

func animate():
	if (velocity.x > 0 or velocity.x < 0):
		animated_sprite.play("walk")

func mushroom_death():
	if health < 1:
		$AnimatedSprite2D.play("death")

func _on_hurt_player_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.hit()


func _on_hurt_zone_body_entered(body: Node2D) -> void:
	if  body.is_in_group("projectiles"):
		health -= 1
	
