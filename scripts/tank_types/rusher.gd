extends "res://scripts/tank.gd"

func _ready():
	super._ready()
	health = 4
	rate_of_fire = 5
	speed = 8
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dash"):
		speed = 10
		rate_of_fire = 7
		await get_tree().create_timer(5).timeout
		speed= 8
		rate_of_fire = 5
