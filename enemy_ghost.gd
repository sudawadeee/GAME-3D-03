extends CharacterBody3D

@export var min_speed = 10
@export var max_speed = 18

var direction_x = 1.0
var initial_rotation_y: float

@onready var stomp_area = $StompArea
@onready var anim  = $"Pivot/Root Scene2/AnimationPlayer"

signal squashed

func _physics_process(_delta):
	move_and_slide()
	if not is_on_floor():
		velocity.y -= 25.0 * _delta / 25.0
	else:
		velocity.y = 0

	
func die():
	squashed.emit()
	if anim and anim.has_animation("CharacterArmature|Death"):
		anim.play("CharacterArmature|Death")
		await anim.animation_finished
	queue_free()
	
func _on_stomp_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player_node = body as CharacterBody3D
		var relative_y = body.global_position.y - global_position.y
		print("StompArea Detected!")
		print("Player Velocity Y:", player_node.velocity.y)
		print("Relative Y:", relative_y)
		
		if relative_y > 0.3 and player_node.velocity.y < -0.05:
			print("STOMP SUCCESS!")
			$StompArea.set_deferred("monitoring", false) 
			die()
			if player_node.has_method("_on_enemy_stomped"):
				player_node._on_enemy_stomped(self)
		else:
			if player_node.has_method("die"):
				player_node.die()
