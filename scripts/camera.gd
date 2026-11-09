extends Camera2D

# Build order step 4: simple follow camera. Child of the Player in main.tscn.
# Smoothing uses Camera2D's built-in position smoothing (tune it on the node); room edges are the node's limits.

@export_group("Look-ahead")
@export var look_ahead: float = 40.0       # px the view shifts toward the movement direction at top speed. 0 = off
@export var look_ahead_speed: float = 2.5  # how fast the shift catches up. Higher = snappier, lower = lazier

@onready var player := get_parent()


func _process(delta: float) -> void:
	var target := look_ahead * clampf(player.velocity.x / player.max_speed, -1.0, 1.0)
	offset.x = lerpf(offset.x, target, 1.0 - exp(-look_ahead_speed * delta))
