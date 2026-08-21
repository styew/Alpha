extends Node


@onready var day_night_manager = $"../DayNightManager"


var current_round := 1

var round_cost := 0.0
var remaining_cost := 0.0


func _ready():

	day_night_manager.phase_changed.connect(_on_phase_changed)

	round_cost = calculate_round_cost()
	remaining_cost = round_cost

	print("Round atual: ", current_round)
	print("Custo total: ", round_cost)
	print("Custo restante: ", remaining_cost)


func _on_phase_changed():

	if day_night_manager.is_day:

		current_round += 1

		round_cost = calculate_round_cost()
		remaining_cost = round_cost

		print("Novo round!")
		print("Round atual: ", current_round)
		print("Custo total: ", round_cost)
		print("Custo restante: ", remaining_cost)


func calculate_round_cost() -> float:

	var r = current_round

	return 10.0 + 3.0 * (r - 1) + 0.15 * pow(r - 1, 2)


func consume_cost(amount: float) -> bool:

	if amount > remaining_cost:

		return false

	remaining_cost -= amount

	return true
