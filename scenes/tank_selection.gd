extends Node2D

func _on_rusher_pressed() -> void:
	Global.tank_type = "rusher"
	get_tree().change_scene_to_file("res://scenes/map.tscn")


func _on_default_pressed() -> void:
	Global.tank_type = "default"
	get_tree().change_scene_to_file("res://scenes/map.tscn")
