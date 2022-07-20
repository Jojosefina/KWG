extends KinematicBody2D

func open():
	$AnimationPlayer.play_backwards("Close")
	
func close():		
	$AnimationPlayer.play("Close")
