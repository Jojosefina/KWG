extends Node2D
class_name Laser

onready var end_gun=$EndOfGun
onready var target=$target



export (PackedScene) var Bullet

onready var end_of_gun=$EndOfGun
onready var shoot_cooldown=$Shoot_Cooldown

func shoot():
	if shoot_cooldown.is_stopped() and Bullet != null:
		var bullet_instance= Bullet.instance()
		var target=$target
		var direction_to_shoot=(target.global_position-end_of_gun.global_position).normalized()
		SenalesGlobales.emit_signal('disparo', bullet_instance, end_of_gun.global_position, direction_to_shoot)
		shoot_cooldown.start()
	
