extends Node


@onready var round_manager = $"../RoundManager"
@onready var day_night_manager = $"../DayNightManager"
@onready var monsters_container = $"../Characters/Monsters"
@onready var spawn_points = $"../SpawnPoints"


@export var enemy_data: Array[EnemyData] = []


func _ready() -> void:

	print("EnemySpawner iniciado")
	print("Quantidade de EnemyData: ", enemy_data.size())

	for data in enemy_data:

		print("-------------------------")
		print("Cena: ", data.enemy_scene)
		print("Custo: ", data.spawn_cost)
		print("Peso: ", data.spawn_weight)
		print("Dia: ", data.day_spawn)
		print("Noite: ", data.night_spawn)

	day_night_manager.phase_changed.connect(_on_phase_changed)


func _on_phase_changed() -> void:

	test_available_monsters()

	spawn_monster()


func get_available_monsters() -> Array[EnemyData]:

	var available: Array[EnemyData] = []

	var current_cost = round_manager.remaining_cost
	var is_day = day_night_manager.is_day


	for data in enemy_data:

		# Verifica se o inimigo pode aparecer nesse período
		if is_day and not data.day_spawn:
			continue

		if not is_day and not data.night_spawn:
			continue


		# Verifica se temos custo suficiente
		if data.spawn_cost > current_cost:
			continue


		available.append(data)


	return available


func test_available_monsters() -> void:

	var available = get_available_monsters()

	print("================================")
	print("INIMIGOS DISPONÍVEIS")
	print("================================")

	for data in available:

		print(
			"Custo:", data.spawn_cost,
			" | Peso:", data.spawn_weight,
			" | Dia:", data.day_spawn,
			" | Noite:", data.night_spawn
		)


func choose_monster() -> EnemyData:

	var available = get_available_monsters()

	if available.is_empty():

		return null


	var total_weight := 0.0

	for data in available:

		total_weight += data.spawn_weight


	var random_value = randf() * total_weight


	for data in available:

		random_value -= data.spawn_weight

		if random_value <= 0:

			return data


	return available.back()


func spawn_monster() -> void:

	var selected = choose_monster()

	if selected == null:

		print("Nenhum inimigo disponível para spawnar.")

		return


	var points = spawn_points.get_children()

	if points.is_empty():

		print("Nenhum SpawnPoint encontrado.")

		return


	# Primeiro tenta gastar o custo
	if not round_manager.consume_cost(selected.spawn_cost):

		print("Não foi possível gastar o custo.")

		return


	# Escolhe um ponto aleatório
	var spawn_point = points.pick_random()


	# Cria o inimigo
	var monster = selected.enemy_scene.instantiate()


	# Coloca dentro do container de monstros
	monsters_container.add_child(monster)


	# Define a posição
	monster.global_position = spawn_point.global_position


	print("================================")
	print("MONSTRO SPAWNADO")
	print("Custo: ", selected.spawn_cost)
	print("Peso: ", selected.spawn_weight)
	print("Posição: ", monster.global_position)
	print("Custo restante: ", round_manager.remaining_cost)
	print("================================")
