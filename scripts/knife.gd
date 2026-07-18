extends Node2D


@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Area2D

var attacking = false
var damage = 10
var weapon_owner 

func _ready():
	hitbox.monitoring = false



#usado apenas no ataque
func attack(direction):
	print("arma entrou")
	if attacking:
		return
		
	attacking= true
	hitbox.monitoring= true
	
	sprite.play("attack_" + direction)
	hitbox_area(direction)
	await sprite.animation_finished
	
	hitbox.monitoring= false
	attacking = false

#usando apenas quando o player nao se move
func static_position(last_direction):
	sprite.play("idle_"+ last_direction)
	
func hitbox_area(direction):
	
	match direction:
			
		"UP":
			hitbox.position = Vector2(-5,-10)
		"DOWN":
			hitbox.position = Vector2(-5,8)
		"LEFT":
			hitbox.position = Vector2(-14,2)
		"RIGHT":
			hitbox.position = Vector2(5,2)


func _on_area_2d_body_entered(body: Node2D) -> void:
		if not attacking:
			return
	
		if body.has_method("take_damage") and body!= weapon_owner:
			body.take_damage(damage)
