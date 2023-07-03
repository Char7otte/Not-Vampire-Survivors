extends Camera2D

var target_position = Vector2.ZERO


func _ready():
	make_current()


func _process(delta):
	acquire_target()
	#Whack exponent math that my C for o-level ass can't understand
	#But just understand that the weight is % of how much global_position will move towards target_position
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))


func acquire_target():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if not player_node == null:
		target_position = player_node.global_position
