extends CharacterBody3D
class_name Champion

const SPEED = 8.0
const DASH_MULTIPLIER = 3.5

var is_dashing: bool = false
var can_dash: bool = true

@onready var dash_duration_timer: Timer = $DashDurationTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var anim_player: AnimationPlayer = $AnimationPlayer # New reference

func _ready():
	dash_duration_timer.timeout.connect(_on_dash_duration_timeout)
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timeout)

func _physics_process(_delta):
	# Attack Logic
	if Input.is_action_just_pressed("attack") and not anim_player.is_playing():
		anim_player.play("attack")

	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
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

func _on_dash_duration_timeout():
	is_dashing = false

func _on_dash_cooldown_timeout():
	can_dash = true
