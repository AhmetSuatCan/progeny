extends CharacterBody2D

# Build order step 3c/3d: coyote time + jump buffering. All forgivenesses in; camera is next.
# Values are placeholders sized for a 640x360 base resolution — tune live in the inspector.

@export_group("Horizontal")
@export var max_speed: float = 150.0       # px/s top speed
@export var acceleration: float = 1000.0   # px/s^2 when pushing toward the input direction
@export var deceleration: float = 1300.0   # px/s^2 when there's no input
@export var turn_speed: float = 2000.0     # px/s^2 when pushing against current velocity (snappy turn-around)

@export_group("Jump")
@export var jump_velocity: float = -360.0  # px/s upward launch speed (negative = up)
@export var gravity_up: float = 900.0      # px/s^2 while rising. Sets full jump height = jump_velocity^2 / (2 * gravity_up) = 72px
@export var gravity_down: float = 1400.0   # px/s^2 while falling. Higher = heavier, snappier landings
@export var max_fall_speed: float = 450.0  # px/s terminal velocity so long drops stay readable
@export_range(0.0, 1.0) var jump_cut: float = 0.5  # upward speed kept when jump is released mid-rise. 1 = no cut (fixed height), lower = shorter taps

@export_group("Forgiveness")
@export var coyote_time: float = 0.1       # s after leaving a ledge you can still jump. 0 = off
@export var jump_buffer: float = 0.1       # s a jump press is remembered before landing. 0 = off

var coyote_timer := -1.0  # >= 0 while a ledge jump is still allowed
var buffer_timer := -1.0  # >= 0 while a jump press is waiting to fire
var can_cut := false      # current jump hasn't been cut yet (each jump cuts at most once)


func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
		velocity.y += (gravity_up if velocity.y < 0.0 else gravity_down) * delta
		velocity.y = minf(velocity.y, max_fall_speed)

	if Input.is_action_just_pressed("jump"):
		buffer_timer = jump_buffer
	else:
		buffer_timer -= delta

	if buffer_timer >= 0.0 and coyote_timer >= 0.0:
		velocity.y = jump_velocity
		buffer_timer = -1.0
		coyote_timer = -1.0
		can_cut = true
	# Not holding jump while rising -> cut. Also covers a buffered tap released before landing.
	if can_cut and velocity.y < 0.0 and not Input.is_action_pressed("jump"):
		velocity.y *= jump_cut
		can_cut = false

	var input_dir := Input.get_axis("move_left", "move_right")

	var rate := deceleration
	if input_dir != 0.0:
		rate = turn_speed if signf(input_dir) != signf(velocity.x) and velocity.x != 0.0 else acceleration
	velocity.x = move_toward(velocity.x, input_dir * max_speed, rate * delta)

	move_and_slide()
