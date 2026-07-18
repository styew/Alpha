extends Node2D

@onready var sprite = $AnimatedSprite2D
var frame
func _ready():

	sprite.play("default")

	frame = randi_range(0, sprite.sprite_frames.get_frame_count("default") - 1)
	sprite.set_frame_progress(randf())
