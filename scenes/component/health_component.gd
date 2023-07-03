extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: float
var current_health

func _ready():
	current_health = max_health

func damage(damage_amount: float):
	#Max will take all the values in it and display the largest one
	#So this prevents current_health from going below 0
	current_health = max((current_health - damage_amount), 0)
	health_changed.emit()
	Callable(check_death).call_deferred()


func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
