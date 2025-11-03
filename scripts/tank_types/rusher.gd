extends "res://scripts/tank.gd"

# --- Ability Settings ---
@export var dash_force: float = 8000.0


@export var ultimate_duration: float = 8.0
@export var ultimate_cooldown: float = 20.0
@export var ultimate_speed_boost: float = 3.0
@export var ultimate_fire_rate_boost: float = 3.0

@export var dash_speed_boost: float = 30.0   # how much speed to add (m/s)
@export var dash_duration: float = 0.25     # how long the boost lasts
@export var dash_cooldown: float = 5.0


var _is_dashing: bool = false


# --- Internal State ---
var can_dash: bool = true
var can_ultimate: bool = true
var is_ult_active: bool = false
var default_speed: float
var default_fire_rate: float

func _ready():
	super._ready()
	default_speed = speed
	default_fire_rate = rate_of_fire


func _unhandled_input(_event: InputEvent) -> void:
		# 🔹 Call parent version so camera + aim rotation still works
	super._unhandled_input(_event)
	if not is_multiplayer_authority():
		return
		
	# --- Dash ---
	if Input.is_action_just_pressed("dash") and can_dash:
		dash_forward()

	# --- Ultimate ---
	if Input.is_action_just_pressed("ultimate") and can_ultimate:
		activate_ultimate()


# ==========================
# DASH ABILITY
# ==========================
func dash_forward() -> void:
	if not can_dash:
		return
	can_dash = false
	_is_dashing = true

	print("⚡ Dash (instant velocity)")

	# compute forward direction (negative z is forward in Godot)
	var forward = -global_transform.basis.z.normalized()

	# immediately add to velocity
	linear_velocity += forward * dash_speed_boost

	# optional camera shake
	shake()

	# stop dash after duration
	await get_tree().create_timer(dash_duration).timeout
	_is_dashing = false

	# start cooldown
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true


# ==========================
# ULTIMATE ABILITY
# ==========================
func activate_ultimate() -> void:
	can_ultimate = false
	is_ult_active = true
	print("🔥 Ultimate Activated!")

	# Buff stats
	speed *= ultimate_speed_boost
	rate_of_fire *= ultimate_fire_rate_boost

	# Optional: glow effect, sound, or camera post-processing
	# Example (if you add a MeshInstance3D for tank body)
	# $Body.material_override.albedo_color = Color(1, 0.6, 0.2)

	# Wait until ultimate ends
	await get_tree().create_timer(ultimate_duration).timeout
	reset_ultimate()


func reset_ultimate() -> void:
	print("❄️ Ultimate Ended!")
	is_ult_active = false

	# Reset stats to default
	speed = default_speed
	rate_of_fire = default_fire_rate

	# Wait before ultimate can be reused
	await get_tree().create_timer(ultimate_cooldown).timeout
	can_ultimate = true
