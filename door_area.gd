extends Node2D

signal win

func _on_Area2D_body_entered(body):
	#se abren las puertas
	if body.is_in_group("Player"):
		emit_signal("win")
		

