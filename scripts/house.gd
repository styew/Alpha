extends Node2D

@onready var roof = $roof
@onready var wall_collision_e = $wallfrontCollisionE
@onready var wall_collision_i = $wallfrontCollisionI
@onready var door = $door

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Entrou:", body.name)
	if body.is_in_group("player"):
		roof.visible = false
		wall_collision_i.modulate.a = 0.3
		wall_collision_e.enabled = false
		wall_collision_i.enabled = true
		door.modulate.a = 0.3

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("Saiu:", body.name)
	if body.is_in_group("player"):
		roof.visible = true
		wall_collision_e.enabled = true
		wall_collision_i.enabled = false
		door.modulate.a = 1.0
