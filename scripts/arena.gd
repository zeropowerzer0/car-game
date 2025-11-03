extends StaticBody3D

func _ready() -> void:
	if not multiplayer.is_server():
		return
	#Host added the player
	multiplayer.peer_connected.connect(add_car)
	add_car(1)
	multiplayer.peer_disconnected.connect(delete_car)

func add_car(id):
	print( "added player : ",id)
	var car = preload("res://scenes/tank.tscn").instantiate()
	
	if Global.tank_type == "rusher":
		car.set_script(load("res://scripts/tank_types/rusher.gd"))
		
	
	car.name=str(id)
	car.position= Vector3(randf_range(-70,70),10,randf_range(-70,70))
	call_deferred("add_child",car)

func delete_car(id):
	rpc("_delete_car",id)
	
@rpc("any_peer","call_local")
func  _delete_car(id):
	get_node(str(id)).queue_free()	
	
