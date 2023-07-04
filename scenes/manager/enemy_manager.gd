extends Node

#Since the viewport length is 640, half of that would be the radius. Any more is 
#just leeway and compensating for the player's movement
const SPAWN_RADIUS = 375

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene

@onready var timer = $Timer
@onready var base_spawn_time = timer.wait_time

var enemy_table = WeightedTable.new()


func _ready():
	enemy_table.add_item(basic_enemy_scene, 10)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		spawn_position = player.global_position + (SPAWN_RADIUS * random_direction)
		var additional_check_offset = random_direction * 20
		
		#It draws a line from player.global_position to spawn_position on Collision Mask 1.
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1 << 0)
		#Checks whether the line intersected anything. If it doesn't, it returns an empty dictionary.
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position

func _on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return;
	
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spawn_position()


func _on_arena_time_manager_arena_difficulty_increased(arena_difficulty):
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 20)
