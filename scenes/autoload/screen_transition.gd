extends CanvasLayer

signal transitioned_halfway

@onready var animation_player = $AnimationPlayer

var skip_emit = false


func transition():
	animation_player.play("in")
	await animation_player.animation_finished
	animation_player.play("out")


func transition_to_scene(scene_path: String):
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file(scene_path)


func emit_transitioned_halfway():
	transitioned_halfway.emit()
