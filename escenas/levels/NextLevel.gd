extends Sprite

func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		print("res://escenas/levels/Nivel2") #+ str(int(get_tree().current_scene.name) + 1) + ".tscn")
		get_tree().change_scene("res://escenas/levels/Nivel2") #+ str(int(get_tree().current_scene.name) + 1) + ".tscn")
