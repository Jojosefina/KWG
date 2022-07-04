extends Character
class_name Enemy

# fisicas
var run_speed = 60
var velocity = Vector2.ZERO
var path: PoolVector2Array
var knockback=Vector2.ZERO
#ai
onready var ai=$AI

#persecucion
onready var timer_agro= $tiempo_agro
onready var visual=$AI/Campo_de_vision
onready var zona_agro=$AI/zona_de_agro

#salud
onready var health_stat= $Salud

#variables
var player 
var target

func _ready()-> void:
	$AnimationTree.active = true
	ai.initialize(self)

func _physics_process(delta):
	knockback=knockback.move_toward(Vector2.ZERO,200*delta)
	knockback=move_and_slide(knockback)
	
	
	
func _chase(velocity):
	#chase
	move_and_slide(velocity)

func handle_hit():
	health_stat.health-=20
	if health_stat.health <=0:
		queue_free()
	print('enemigo dañado', health_stat.health)





func _on_Hurtbox_body_entered(body):
	if body is Player:
		knockback=body.melee_area.knockback_vector*120
