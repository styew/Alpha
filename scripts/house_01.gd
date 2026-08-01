extends Node2D


@onready var roof = $roof
@onready var front_wall = $walls_front


func enter_house():

	roof.visible = false

	var color = front_wall.modulate
	color.a = 0.3
	front_wall.modulate = color


func exit_house():

	roof.visible = true

	var color = front_wall.modulate
	color.a = 1
	front_wall.modulate = color


func _on_interior_area_body_entered(body: Node2D) -> void:
	print("entrou na casa:", body.name)
	if body.is_in_group("player"):
		enter_house()


func _on_interior_area_body_exited(body: Node2D) -> void:

	if body.is_in_group("player"):
		exit_house()
