extends Node2D
@onready var tank_selection: Node2D = $"."

func _on_rusher_pressed() -> void:
	Global.tank_type = "rusher"
	tank_selection.hide()


func _on_default_pressed() -> void:
	Global.tank_type = "default"
	tank_selection.hide()
