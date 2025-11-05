extends Node2D
@onready var tank_selection: Node2D = $"."

func _on_rusher_pressed() -> void:
	Global.tank_type = "rusher"
	tank_selection.hide()


func _on_defender_pressed() -> void:
	Global.tank_type = "defender"
	get_tree().change_scene_to_file("res://scenes/map.tscn")
