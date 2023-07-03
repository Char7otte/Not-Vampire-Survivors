extends PanelContainer

signal selected

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var animation_player = $AnimationPlayer

var disabled = false


func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")

func play_discard():
	animation_player.play("discard")


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func select_card():
	disabled = true
	animation_player.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self:
			continue
		other_card.play_discard()
		
	await animation_player.animation_finished
	selected.emit()



func _on_gui_input(event):
	if disabled:
		return
	
	if event.is_action_pressed("left_click"):
		select_card()


func _on_mouse_entered():
	if disabled:
		return
	
	$HoverAnimationPlayer.play("hover")
