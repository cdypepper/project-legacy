extends Area3D
class_name HurtboxComponent

# This will appear in the Inspector so we can link the HealthComponent
@export var health_component: HealthComponent

func take_damage(damage: int):
	# If a HealthComponent is linked, tell it to subtract the damage
	if health_component:
		health_component.take_damage(damage)
	else:
		print("Warning: Hurtbox took damage but has no HealthComponent linked!")
