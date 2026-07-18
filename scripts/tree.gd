extends AnimatedSprite2D


func _ready():

	play("default")

	frame = randi_range(0, sprite_frames.get_frame_count("default") - 1)
	set_frame_progress(randf())
