extends CharacterBody2D

enum State{
	IDLE,CHASE,ATTACK
}

const SPEED = 25.0
const DETECTION_RADIUS = 50.0

var health = 50
var last_direction = "DOWN"
var attacking = false
var current_state = State.IDLE
var can_attack = true
const ATTACK_COOLDOWN = 1
var player_in_attack_range = false
var player = null
var damage = 10

@onready var sprite = $AnimatedSprite2D



func _ready():
	floor_snap_length = 0
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING


func _physics_process(_delta):

	if attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return


	if player != null:

		if player_in_attack_range:
			velocity = Vector2.ZERO
			attack()

		else:
			current_state = State.CHASE

			var direction = global_position.direction_to(player.global_position)

			update_direction(direction)

			velocity = direction * SPEED


	else:
		current_state = State.IDLE
		velocity = Vector2.ZERO


	move_and_slide()
	update_animation()

func take_damage(amount):
	health -= amount
	print("health of enemy ",health)
	if health <= 0:
		die()
		queue_free()
		
func die():
	print("death")

# Vector direction the Enemy look
func update_direction(direction):
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			last_direction = "RIGHT"
		else:
			last_direction = "LEFT"
	else:
		if direction.y > 0:
			last_direction = "DOWN"
		else:
			last_direction = "UP"
			
func update_animation():
	match current_state:
		State.IDLE:
			sprite.play("IDLE_" + last_direction)
		State.CHASE:
			sprite.play(last_direction)
		State.ATTACK:
			sprite.play("attack_" + last_direction)
			
func attack():
	if not can_attack:
		return
	attacking = true
	can_attack = false
	
	current_state = State.ATTACK
	velocity = Vector2.ZERO
	update_animation()
	await sprite.animation_finished
	if player != null and player_in_attack_range:
		player.take_damage(damage)
	attacking = false
	current_state = State.IDLE
	await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	can_attack = true



func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_detection_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = true


func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = false
