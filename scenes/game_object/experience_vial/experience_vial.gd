extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite_2d = $Sprite2D

func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))
	sprite_2d.scale = sprite_2d.scale.lerp(Vector2.ONE * 1.2, percent)

func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


func disable_collision():
	collision_shape_2d.disabled = true


func _on_area_2d_area_entered(_area):
	Callable(disable_collision).call_deferred()
	
	var tween = create_tween()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1, 0.5)\
	.set_ease(tween.EASE_IN).set_trans(tween.TRANS_BACK)
	tween.tween_callback(collect)
	
	$RandomStreamPlayer2DComponent.play_random()
