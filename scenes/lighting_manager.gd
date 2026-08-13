extends Node


@onready var canvas_modulate = $"../CanvasModulate"
@onready var day_night_manager = $"../DayNightManager"


var day_color := Color.WHITE
var night_color := Color(0.15, 0.15, 0.2)

var current_color := Color.WHITE
var target_color := Color.WHITE

var transition_duration := 5.0
var transition_time := 0.0


func _ready():

	day_night_manager.phase_changed.connect(_on_phase_changed)

	current_color = day_color
	target_color = day_color

	canvas_modulate.color = current_color


func _process(delta):

	if current_color != target_color:

		transition_time += delta

		var progress = transition_time / transition_duration
		progress = clamp(progress, 0.0, 1.0)

		current_color = current_color.lerp(target_color, progress)

		canvas_modulate.color = current_color

		if progress >= 1.0:
			current_color = target_color


func _on_phase_changed():

	if day_night_manager.is_day:
		set_day()
	else:
		set_night()


func set_day():

	target_color = day_color
	transition_time = 0.0


func set_night():

	target_color = night_color
	transition_time = 0.0
