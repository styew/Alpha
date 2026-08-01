extends Node2D


var closed := true
var locked := false
var player_near = null


@onready var sprite = $AnimatedSprite2D

@onready var collision_close = $StaticBody2D_Close/CollisionShape2D
@onready var collision_open = $StaticBody2D_Open/CollisionShape2D
@onready var interaction_label = $InteractionLabel


func _ready():
	open()
	print("porta carregada")


func interact():

	if closed:
		open()
	else:
		close()


func open():

	if locked:
		return

	closed = false

	collision_close.disabled = true
	collision_open.disabled = false

	sprite.play("open")


func close():

	if locked:
		return

	closed = true

	collision_close.disabled = false
	collision_open.disabled = true

	sprite.play("closed")


func lock():
	locked = true


func unlock():
	locked = false


func _on_interaction_area_body_entered(body):

	print("Entrou na área:", body.name)

	if body.is_in_group("player"):
		print("Player detectado!")
		player_near = body
		body.current_interactable = self
		update_prompt()


func _on_interaction_area_body_exited(body):

	print("Saiu da área:", body.name)

	if body.is_in_group("player"):

		if body.current_interactable == self:
			body.current_interactable = null

		player_near = null
		interaction_label.visible = false

		
func update_prompt():

	if closed:
		interaction_label.text = "[E] Abrir porta"
	else:
		interaction_label.text = "[E] Fechar porta"

	interaction_label.visible = true
