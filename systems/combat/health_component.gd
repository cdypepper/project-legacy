extends Node
class_name HealthComponent

signal health_changed(new_health, max_health)
signal died

@export var max_health: int = 100
var current_health: int

func _ready():
	# Set our health to full when the entity spawns into the world
	current_health = max_health

func take_damage(amount: int):
	# Subtract the damage and prevent health from dropping below zero
	current_health -= amount
	current_health = max(current_health, 0)
	
	# Broadcast to the game that our health changed
	health_changed.emit(current_health, max_health)
	
	# Check if we should die
	if current_health == 0:
		died.emit()
