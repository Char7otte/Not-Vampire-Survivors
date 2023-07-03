extends Node

@export_range(0, 1) var drop_percent: float = 0.5
@export var health_component: HealthComponent
@export var experience_vial_scene: PackedScene

func _ready():
	health_component.died.connect(on_health_component_died)


func on_health_component_died():
	if randf() > drop_percent:
		return
	if experience_vial_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var spawn_position = owner.global_position
	var experience_vial_instance = experience_vial_scene.instantiate()
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(experience_vial_instance)
	experience_vial_instance.global_position = spawn_position
