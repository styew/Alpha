extends Node2D


@onready var roof = $roof
@onready var front_wall = $walls_front
@onready var house_light = $HouseLight/PointLight2D

@onready var lighting_manager = $"../LightingManager"
@onready var day_night_manager = $"../DayNightManager"


func _ready() -> void:

	house_light.enabled = false

	day_night_manager.phase_changed.connect(_on_phase_changed)


func enter_house():

	roof.visible = false

	var color = front_wall.modulate
	color.a = 0.3
	front_wall.modulate = color

	lighting_manager.set_player_inside(true)

	_update_house_light()


func exit_house():

	roof.visible = true

	var color = front_wall.modulate
	color.a = 1.0
	front_wall.modulate = color

	house_light.enabled = false

	lighting_manager.set_player_inside(false)


func _update_house_light():

	if lighting_manager.is_night() and lighting_manager.player_inside:
		house_light.enabled = true
	else:
		house_light.enabled = false


func _on_phase_changed():

	_update_house_light()


func _on_interior_area_body_entered(body: Node2D) -> void:

	print("entrou na casa:", body.name)

	if body.is_in_group("player"):
		enter_house()


func _on_interior_area_body_exited(body: Node2D) -> void:

	if body.is_in_group("player"):
		exit_house()
