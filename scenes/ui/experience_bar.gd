extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar = $%ProgressBar


func _ready():
	progress_bar.value = 0


func _on_experience_manager_experience_updated(current_experience, target_experience):
	var percent = current_experience / target_experience
	progress_bar.value = percent
