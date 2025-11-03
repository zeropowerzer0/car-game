extends "res://scripts/tank.gd"

func _ready():
	super._ready()
	rate_of_fire = 10
	speed = 10
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dash"):
		speed = 100
		await get_tree().create_timer(5).timeout
		speed= 10
