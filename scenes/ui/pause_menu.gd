extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var panel_container = %PanelContainer
@onready var resume_button = %ResumeButton
@onready var options_button = %OptionsButton
@onready var quit_button = %QuitButton

var options_menu_scene = preload("res://scenes/ui/options_menu.tscn")
var is_closing


func _ready():
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2
	
	animation_player.play("default")
	
	resume_button.pressed.connect(on_resume_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()


func close():
	if is_closing:
		return
	
	is_closing = true
	animation_player.play_backwards("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	await tween.finished
	
	get_tree().paused = false
	queue_free()


func on_resume_button_pressed():
	close()


func on_options_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	var options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	options_menu_instance.back_pressed.connect(on_options_menu_back_button_pressed.bind(options_menu_instance))


func on_quit_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func on_options_menu_back_button_pressed(options_menu_instance):
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	options_menu_instance.queue_free()
