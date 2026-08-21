extends Node


signal phase_changed
signal round_changed


var current_round := 1
var is_day := true

var day_duration := 10.0
var night_duration := 10.0

var time_remaining := day_duration



func _process(delta):

	time_remaining -= delta

	if time_remaining <= 0:
		change_phase()


func change_phase():

	if is_day:

		is_day = false
		time_remaining = night_duration

		print("NOITE - Round ", current_round)

		phase_changed.emit()

	else:

		is_day = true
		current_round += 1
		time_remaining = day_duration

		print("DIA - Round ", current_round)

		phase_changed.emit()
		round_changed.emit()
