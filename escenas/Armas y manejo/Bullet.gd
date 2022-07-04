extends Area2D
class_name Bullet


export(int) var speed=10

var direction := Vector2.ZERO

onready var kill_timer=$KillTimer

func _ready() -> void:
	kill_timer.start()


func _process(delta:float)-> void:
	if direction != Vector2.ZERO:
		var velocity=direction*speed
		
		global_position+= direction*speed

func set_direction(direction: Vector2):
	self.direction=direction
	
func _on_KillTimer_timeout() -> void:
	queue_free()


func _on_Bullet_body_entered(body):
	if body.has_method('handle_hit') and body is KinematicBody2D:
		body.handle_hit()
		queue_free()
