extends CanvasLayer

func _ready():
	$Panel.hide()

func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://escenas/Menu/MainMenu.tscn")

func _on_quit_pressed():
	get_tree().quit()

# Cuando pierde, aparece una pantalla de derrota. 
func activate():
	get_tree().paused = true
	$Panel.show()
