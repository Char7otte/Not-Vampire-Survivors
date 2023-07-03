extends CanvasLayer

@onready var play_button = %PlayButton
@onready var options_button = %OptionsButton
@onready var quit_button = %QuitButton

var options_menu_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready():
	play_button.pressed.connect(on_play_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)


func on_play_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	var options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	options_menu_instance.back_pressed.connect(on_options_menu_back_button_pressed.bind(options_menu_instance))


func on_quit_button_pressed():
	get_tree().quit()

func on_options_menu_back_button_pressed(options_menu_instance):
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	options_menu_instance.queue_free()
