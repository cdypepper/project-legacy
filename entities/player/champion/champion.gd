extends CharacterBody3D
class_name Champion

const SPEED = 8.0

func _physics_process(_delta):
	# Get the input direction as a 2D vector based on our Input Map
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Convert that 2D input into 3D space (X and Z axes, ignoring Y which is up/down)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		# If we are pressing a direction, move at our SPEED
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# If we let go, immediately stop (keeps combat feeling snappy and tight)
		velocity.x = 0
		velocity.z = 0
		
	# Godot's built-in function to handle moving and colliding with walls/floors
	move_and_slide()
