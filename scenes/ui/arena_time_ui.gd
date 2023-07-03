extends CanvasLayer

@export var arena_time_manager: Node

@onready var label = $%Label


func _process(_delta):
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)


func format_seconds_to_string(seconds: float):
	var minutes = floor(seconds / 60)
	var remaining_seconds = seconds - (minutes * 60)
	#String formatting e.g. "%020D"
	#The first 0 is to replace extra space with zeroes; 
	#having no 0 in front will just be blank characters.
	#While the 20 is paired with d(which means decimal/integer) to display up to 20 characters.
	return str(minutes) + ":" + ("%02d" % remaining_seconds)
