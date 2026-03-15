extends CharacterBody3D
class_name Champion

const SPEED = 8.0
const DASH_MULTIPLIER = 3.5
const ATTACK_DAMAGE = 1
const ROTATION_SPEED = 15.0 # Speed of the smoothing

var is_dashing: bool = false
var can_dash: bool = true

@onready var dash_duration_timer: Timer = $DashDurationTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	add_to_group("Player")
	dash_duration_timer.timeout.connect(_on_dash_duration_timeout)
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timeout)

func _physics_process(delta):
	# 1. Handle Orientation with Smoothing
	handle_mouse_rotation(delta)

	# 2. Attack Logic
	if Input.is_action_just_pressed("attack") and not anim_player.is_playing():
		anim_player.play("attack", -1, 2.0)

	# 3. Global Movement Logic
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# We REMOVED (transform.basis *) here. 
	# Now Vector3(input_dir.x, 0, input_dir.y) refers to world coordinates.
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if Input.is_action_just_pressed("dash") and can_dash and direction != Vector3.ZERO:
		is_dashing = true
		can_dash = false
		dash_duration_timer.start()
		dash_cooldown_timer.start()
		
	var current_speed = SPEED * DASH_MULTIPLIER if is_dashing else SPEED
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = 0
		velocity.z = 0
		
	move_and_slide()

func handle_mouse_rotation(delta):
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return

	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	
	var t = -ray_origin.y / ray_direction.y
	var target_pos = ray_origin + ray_direction * t
	
	# Determine the point to look at
	var target_vector = Vector3(target_pos.x, global_position.y, target_pos.z)
	
	# Only rotate if the mouse is far enough away to avoid "spinning" glitches
	if global_position.distance_to(target_vector) > 0.1:
		# We create a temporary Transform to find the target rotation
		var target_transform = transform.looking_at(target_vector, Vector3.UP)
		
		# Slerp (Spherical Linear Interpolation) smoothly rotates from Current to Target
		transform.basis = transform.basis.slerp(target_transform.basis, ROTATION_SPEED * delta)

func _on_dash_duration_timeout():
	is_dashing = false

func _on_dash_cooldown_timeout():
	can_dash = true

func _on_hitbox_component_area_entered(area):
	var enemy = area.get_parent()
	if enemy.has_method("take_damage"):
		enemy.take_damage(ATTACK_DAMAGE, global_position)
