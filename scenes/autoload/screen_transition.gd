extends CanvasLayer

signal transitioned_halfway

@onready var animation_player = $AnimationPlayer

var skip_emit = false


func transition():
	animation_player.play("in")
	await animation_player.animation_finished
	animation_player.play("out")


func emit_transitioned_halfway():
	transitioned_halfway.emit()
