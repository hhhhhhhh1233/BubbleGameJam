class_name HealthComponent
extends Node3D

signal damage_taken
signal health_restore
signal health_depleted

@export var max_health = 100

@onready var health = max_health

func Damage(Amount):
	health = max(health - Amount, 0)
	damage_taken.emit()
	if health <= 0:
		health_depleted.emit()

func Heal(Amount):
	health = min(health + Amount, max_health)
	
	health_restore.emit()
