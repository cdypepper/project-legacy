extends Area3D
class_name HitboxComponent

@export var damage: int = 10

func _ready():
	# We connect the built-in Godot signal 'area_entered' to our custom function
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D):
	# Check if the area we just hit is a Hurtbox
	if area is HurtboxComponent:
		area.take_damage(damage)
