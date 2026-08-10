extends Area2D

var checkpoint_manager2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_manager2 = get_parent()
	

#sets player's last location to a new location for respawn
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.set_collision_mask_value(1, true)
		body.set_collision_mask_value(2, true)
		body.set_collision_mask_value(3, true)
		body.health = 1
		body.direction = 0
		body.double_jumps = 0
		body.is_wall_sliding = false
		body.friction = 100
		body.is_dashing = false
		body.can_dash = true
		body.dash_speed = 3
		body.isHit = false
		body.wall_direction = 0
		body.dead = false
		checkpoint_manager2.last_location = $RespawnPoint.global_position
		print("Checkpoint activated at position: ", checkpoint_manager2.last_location)
