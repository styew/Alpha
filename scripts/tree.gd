extends StaticBody2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("default")

	var frame = randi_range(
		0,
		sprite.sprite_frames.get_frame_count("default") - 1
	)

	sprite.set_frame(frame)
	sprite.set_frame_progress(randf())
