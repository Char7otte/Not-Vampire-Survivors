extends Node

const MAX_RANGE = 150.0

@export var sword_ability: PackedScene
@export var base_damage = 5

@onready var base_wait_time = $Timer.wait_time

var additional_damage_percent = 1


func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	#Filters out the enemies not within MAX_RANGE of the player, removing them from enemies[].
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	
	#Each element in enemies[] is compared to each other 2 at a time, 
	#Eventually sorting the array to least distance to furthest.
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	#Instantiates a sword and assigns it as a child of player.
	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = base_damage * additional_damage_percent
	
	#The instantiated sword spawns on enemies[0]; the closest enemy.
	sword_instance.global_position = enemies[0].global_position
	#Vector2.RIGHT is going completely straight horizontally. We rotate it randomly in 360 degrees(TAU is 2PI)
	#4 is the offset away from the enemy so that the rotation does something.
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	#This takes 2 vectors and calculates the angle they're going at.
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
	elif upgrade.id == "sword_damage":
		additional_damage_percent = 1 + (current_upgrades["sword_damage"]["quantity"] * 0.15)
