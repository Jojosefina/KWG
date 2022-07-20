extends Node2D


func _ready():
	$AnimationPlayer.play("death")


func purge():
	queue_free()

func mirror():
	scale.x=-1

