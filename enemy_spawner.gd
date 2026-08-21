extends Node


@onready var round_manager = $"../RoundManager"
@onready var day_night_manager = $"../DayNightManager"
@onready var monsters_container = $"../Characters/Monsters"
@onready var spawn_points = $"../SpawnPoints"


@export var enemy_data: Array[EnemyData] = []


# ==========================================
# CONFIGURAÇÃO DOS SLOTS
# ==========================================

const DAY_SLOTS := 10
const NIGHT_SLOTS := 10
const MAX_MONSTERS := 20


# ==========================================
# CONTROLE DE SPAWN
# ==========================================

@export var spawn_interval := 2.0

var spawn_timer := 0.0


# ==========================================
# READY
# ==========================================

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


# ==========================================
# PROCESS
# ==========================================

func _process(delta: float) -> void:

	spawn_timer += delta


	if spawn_timer >= spawn_interval:

		spawn_timer = 0.0

		try_spawn()


# ==========================================
# MUDANÇA DE FASE
# ==========================================

func _on_phase_changed() -> void:

	# Reinicia o timer quando começa
	# uma nova fase.

	spawn_timer = 0.0


	test_available_monsters()


	print("================================")
	print("MUDANÇA DE FASE")
	print("================================")


	if day_night_manager.is_day:

		print("FASE: DIA")

	else:

		print("FASE: NOITE")


	print(
		"Monstros totais: ",
		monsters_container.get_child_count()
	)


	print(
		"Slots disponíveis da fase: ",
		get_available_phase_slots()
	)


# ==========================================
# TENTAR SPAWNAR
# ==========================================

func try_spawn() -> void:

	# Verifica se existe slot disponível.

	if get_available_phase_slots() <= 0:

		return


	# Verifica se ainda existe custo.

	if round_manager.remaining_cost <= 0:

		return


	# Verifica se existe algum inimigo
	# que possa aparecer.

	var available = get_available_monsters()


	if available.is_empty():

		return


	# Tudo certo.

	spawn_monster()


# ==========================================
# INIMIGOS DISPONÍVEIS
# ==========================================

func get_available_monsters() -> Array[EnemyData]:

	var available: Array[EnemyData] = []

	var current_cost = round_manager.remaining_cost
	var is_day = day_night_manager.is_day


	for data in enemy_data:

		# Verifica se o inimigo pode aparecer
		# durante o período atual.

		if is_day and not data.day_spawn:

			continue


		if not is_day and not data.night_spawn:

			continue


		# Verifica se existe custo suficiente.

		if data.spawn_cost > current_cost:

			continue


		available.append(data)


	return available


# ==========================================
# TESTE DOS INIMIGOS DISPONÍVEIS
# ==========================================

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


# ==========================================
# ESCOLHA DO INIMIGO
# ==========================================

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


# ==========================================
# SPAWN DE UM INIMIGO
# ==========================================

func spawn_monster() -> void:

	var selected = choose_monster()


	if selected == null:

		print("Nenhum inimigo disponível para spawnar.")

		return


	var points = spawn_points.get_children()


	if points.is_empty():

		print("Nenhum SpawnPoint encontrado.")

		return


	# Verifica novamente se temos custo suficiente.

	if not round_manager.consume_cost(selected.spawn_cost):

		print("Não foi possível gastar o custo.")

		return


	# Escolhe um SpawnPoint aleatório.

	var spawn_point = points.pick_random()


	# Instancia o inimigo.

	var monster = selected.enemy_scene.instantiate()


	# Guarda a fase em que o inimigo nasceu.

	if day_night_manager.is_day:

		monster.set_meta("spawn_phase", "day")

	else:

		monster.set_meta("spawn_phase", "night")


	# Coloca o inimigo no container.

	monsters_container.add_child(monster)


	# Define a posição.

	monster.global_position = spawn_point.global_position


	print("================================")
	print("MONSTRO SPAWNADO")
	print("Custo: ", selected.spawn_cost)
	print("Peso: ", selected.spawn_weight)
	print("Fase: ", monster.get_meta("spawn_phase"))
	print("Posição: ", monster.global_position)
	print("Custo restante: ", round_manager.remaining_cost)
	print("================================")


# ==========================================
# CONTAGEM DE MONSTROS POR FASE
# ==========================================

func get_phase_monster_count(phase: String) -> int:

	var count := 0


	for monster in monsters_container.get_children():

		if monster.has_meta("spawn_phase"):

			if monster.get_meta("spawn_phase") == phase:

				count += 1


	return count


# ==========================================
# SLOTS DISPONÍVEIS DA FASE ATUAL
# ==========================================

func get_available_phase_slots() -> int:

	var phase := ""


	if day_night_manager.is_day:

		phase = "day"

	else:

		phase = "night"


	# Quantos monstros desta fase existem?

	var current_count = get_phase_monster_count(phase)


	# Quantos slots a fase possui?

	var max_slots := 0


	if phase == "day":

		max_slots = DAY_SLOTS

	else:

		max_slots = NIGHT_SLOTS


	# Slots disponíveis nesta fase.

	var available_slots = max_slots - current_count


	# Limite global de monstros.

	var total_monsters = monsters_container.get_child_count()

	var global_slots = MAX_MONSTERS - total_monsters


	# Retorna o menor limite.

	return min(available_slots, global_slots)
