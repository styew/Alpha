extends CharacterBody2D


@onready var sprite = $AnimatedSprite2D
@onready var weapon = $WeaponHolder/Knife


var last_direction = "DOWN"
var attacking = false
var health= 50
const SPEED = 100


func _physics_process(delta):

	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)


	if Input.is_action_just_pressed("attack"):
		attack()


	if not attacking:

		velocity = direction * SPEED

		move_and_slide()

		update_direction(direction)
		update_animation(direction)
		update_animation_weapon(direction)

	else:

		velocity = Vector2.ZERO

func update_animation_weapon(direction):
	weapon.static_position(last_direction)

func update_direction(direction):

	if direction.x < 0:
		last_direction = "LEFT"

	elif direction.x > 0:
		last_direction = "RIGHT"

	elif direction.y < 0:
		last_direction = "UP"

	elif direction.y > 0:
		last_direction = "DOWN"


func attack():
	weapon.weapon_owner = self
	if attacking:
		return

	print("entrou")
	attacking = true
	sprite.play("attack_" + last_direction)
	weapon.attack(last_direction)
	await sprite.animation_finished
	attacking = false

	


func update_animation(direction):
	
	

	if direction == Vector2.ZERO:

		match last_direction:

			"DOWN":
				sprite.play("IDLE_DOWN")

			"UP":
				sprite.play("IDLE_UP")

			"LEFT":
				sprite.play("IDLE_LEFT")

			"RIGHT":
				sprite.play("IDLE_RIGHT")


	else:

		sprite.play(last_direction)
		
func take_damage(amount):
	health -= amount
	print("health of player ",health)
	if health <= 0:
		die()
		
func die():
	print("player morreu")
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
		
		
