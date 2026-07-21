extends CanvasLayer

@onready var health_bar = $HealthBar

func update_health(value):
	health_bar.value = value

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	
	player.health_changed.connect(update_health)

	health_bar.max_value = player.health
	health_bar.value = player.health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
