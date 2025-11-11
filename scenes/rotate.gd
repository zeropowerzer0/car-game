extends StaticBody3D
@onready var vehicle_body_3d = $VehicleBody3D

func _ready() -> void:
	vehicle_body_3d.gravity_scale=4
	vehicle_body_3d.name_label.text=""
	vehicle_body_3d.set_process(false)
	vehicle_body_3d.set_physics_process(false)
func _process(_delta: float) -> void:
	rotate_y(0.01)
