extends CanvasLayer

func _ready():
	set_visible(false)
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused
		
func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible 


func _on_continue_pressed():
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused
	

func _on_exit_pressed():
	get_tree().quit()
	
