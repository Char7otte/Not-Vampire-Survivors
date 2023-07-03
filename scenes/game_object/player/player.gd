extends CharacterBody2D

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent

var number_of_colliding_bodies = 0
@onready var base_speed = velocity_component.max_speed


func _ready():
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()

func _process(_delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if not movement_vector.x == 0 || not movement_vector.y == 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	var move_sign = sign(movement_vector.x)
	if not move_sign == 0:
		visuals.scale = Vector2(move_sign, 1)

func get_movement_vector():
	#get_action_strength on keyboard keys will return either a 1 or a 0, so if move_right is pressed, 
	#it'll be 1 - 0.
	#IE: x_movement = 1
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_of_colliding_bodies == 0 || not damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func _on_collision_area_2d_body_entered(_body):
	number_of_colliding_bodies += 1
	check_deal_damage()


func _on_collision_area_2d_body_exited(_body):
	number_of_colliding_bodies -= 1


func _on_damage_interval_timer_timeout():
	check_deal_damage()


func _on_health_component_health_changed():
	GameEvents.emit_player_damaged()
	health_bar.value = health_component.get_health_percent()
	$HitRandomStreamPlayer.play_random()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = \
		base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * 0.1)
