extends CharacterBody3D

const SPEED = 4.0
var health: int = 3
var knockback: Vector3 = Vector3.ZERO

@export var target: Node3D

func _ready():
	target = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	if knockback.length() > 0.1:
		knockback = knockback.move_toward(Vector3.ZERO, delta * 50.0)
		velocity = knockback
	elif target:
		var direction = global_position.direction_to(target.global_position)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		look_at(target.global_position, Vector3.UP)
	else:
		velocity.x = 0
		velocity.z = 0
		
	move_and_slide()

func take_damage(amount: int, attacker_position: Vector3):
	health -= amount
	
	var push_direction = attacker_position.direction_to(global_position)
	push_direction.y = 0 
	knockback = push_direction.normalized() * 15.0
	
	if health <= 0:
		queue_free()
