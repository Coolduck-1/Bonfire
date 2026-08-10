extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const WALL_JUMP_FORCE = Vector2(200, - 300)

@onready var animated_sprite = $AnimatedSprite2D
var direction = 0
var double_jumps = 0



func animate():
	if (velocity.x == 0 and velocity.y == 0):
		animated_sprite.play("idle")

	if (is_on_floor() and velocity.y < 0):
		animated_sprite.play("jump")

	if (velocity.y < 0):
		animated_sprite.play("jump")

	if  ((velocity.x > 0 or velocity.x < 0) and (velocity.y == 0)):
		animated_sprite.play("running")

func double_jump():
	if(not is_on_floor() and double_jumps < 1 and Input.is_action_just_pressed("ui_accept")):
		velocity.y = JUMP_VELOCITY
		double_jumps += 1
		if (is_on_floor()):
			double_jumps = 0

func get_direction():
	direction = Input.get_axis("ui_left", "ui_right")
	if direction > 0:
		animated_sprite.flip_h = false
	if direction < 0:
		animated_sprite.flip_h = true



var is_wall_sliding = false
var friction = 100
var wall_direction = 0
var can_jump = true


func _physics_process(delta: float) -> void:
	get_direction()
	animate()
	double_jump()
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	wall_slide()
 	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor() or is_on_wall():
		can_jump = true
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false
	
func wall_slide():
	if (is_on_wall()):
		if Input.is_action_pressed("ui_left"):
			wall_direction = -1
			is_wall_sliding = true
			
		elif Input.is_action_just_pressed("ui_right"):
			wall_direction = 1
			is_wall_sliding = true
		else:
			is_wall_sliding = false
		
	else:
		is_wall_sliding = false
		
	if is_wall_sliding:
		velocity.y = friction
	
	if Input.is_action_just_pressed("ui_accept"):
		velocity.x = -wall_direction * WALL_JUMP_FORCE.x
		velocity.y = WALL_JUMP_FORCE.y
		is_wall_sliding = false


	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
