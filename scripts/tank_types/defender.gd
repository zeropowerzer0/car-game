
extends "res://scripts/tank.gd"
@onready var csg_box_3d: CSGBox3D = $CSGBox3D

func _ready():
	super._ready()
	health = 6
	rate_of_fire = 3.5
	speed = 5
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dash"):
		var shield = preload("res://scenes/new_scenes/shield.tscn").instantiate()
		shield.global_position = csg_box_3d.global_position
		get_parent().add_child(shield)
		await get_tree().create_timer(10).timeout
		shield.queue_free()
		
