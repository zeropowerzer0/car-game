extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rotation_cyl: MeshInstance3D = $MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("entryAni")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_cyl.rotate_y(deg_to_rad(45.0 * delta))
