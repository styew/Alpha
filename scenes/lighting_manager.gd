extends Node


@onready var canvas_modulate = $"../CanvasModulate"
@onready var day_night_manager = $"../DayNightManager"
@onready var player_light = $"../Characters/Player/playerLight/PointLight2D"


var day_color := Color.WHITE
var night_color := Color(0.15, 0.15, 0.2)

var current_color := Color.WHITE
var target_color := Color.WHITE

var transition_duration := 5.0
var transition_time := 0.0

var player_inside := false


func _ready():

	day_night_manager.phase_changed.connect(_on_phase_changed)

	current_color = day_color
	target_color = day_color

	canvas_modulate.color = current_color

	player_light.enabled = false


func _process(delta):

	if current_color != target_color:

		transition_time += delta

		var progress = transition_time / transition_duration
		progress = clamp(progress, 0.0, 1.0)

		current_color = current_color.lerp(target_color, progress)

		canvas_modulate.color = current_color

		if progress >= 1.0:
			current_color = target_color


func is_night() -> bool:

	return not day_night_manager.is_day


func set_player_inside(value: bool):

	player_inside = value

	if player_inside:

		# Dentro da casa não precisamos da luz do jogador
		player_light.enabled = false

	else:

		# Fora da casa, a luz só funciona durante a noite
		player_light.enabled = is_night()


func _on_phase_changed():

	if day_night_manager.is_day:

		set_day()

	else:

		set_night()


func set_day():

	target_color = day_color
	transition_time = 0.0

	# Durante o dia a luz do jogador fica desligada
	player_light.enabled = false


func set_night():

	target_color = night_color
	transition_time = 0.0

	# Durante a noite:
	# fora da casa = ligada
	# dentro da casa = desligada
	player_light.enabled = not player_inside
