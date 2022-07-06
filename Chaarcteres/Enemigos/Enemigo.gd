extends KinematicBody2D
class_name Enemy

var facing_right = true
var facing_down= true
var hurt=false
onready var PLAYBACK = $AnimationTree.get("parameters/playback")
onready var tween_knockback=$tween_knockback
onready var tween_modulate=$tween_modulate
onready var animation_player=$AnimationPlayer

# fisicas
var run_speed = 60
var velocity = Vector2.ZERO
var path: PoolVector2Array
var knockback_vector=Vector2.ZERO
var knockback_force = 320

#ai
onready var ai=$AI
#persecucion y ataques
onready var timer_agro= $tiempo_agro
onready var visual=$AI/Campo_de_vision
onready var zona_agro=$AI/zona_de_agro
onready var melee_area=$melee_area
onready var timer_knockback=$timer_knockback

#salud
onready var health_stat= $Salud
onready var barra_salud=$HealthBar/HealthBar

#variables
var player #jugador dentro del campo de vision
var target #jugador dentro de la zona de agro

func _ready()-> void:
	$AnimationTree.active = true
	ai.initialize(self)
	barra_salud.max_value=health_stat.MAX_HEALTH
	barra_salud.value=health_stat.health

func _physics_process(delta):
	#animaciones
	if velocity.length() >= 5:
		PLAYBACK.travel("run")
		if ai.current_state==ai.State.AGRO:
			PLAYBACK.travel("agro")
	else:
		PLAYBACK.travel("Idle")

func _chase(velocity):
	move_and_slide(velocity)

func handle_hit(knockback:Vector2):
	health_stat.health-=20
	barra_salud.value=health_stat.health
	if health_stat.health <=0:
		queue_free()
	ai.set_state(ai.State.AGRO)
	#animacion de daño
	animation_player.play("daño")
	#knockback
	knockback_vector=knockback*knockback_force
	tween_knockback.interpolate_method(self,'move_and_slide',knockback_vector,Vector2.ZERO, 1, Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween_knockback.start()
	#modulacion de color
	tween_modulate.interpolate_property(self,'modulate',Color.red,Color.white, 1,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween_modulate.start()

func _on_melee_body_entered(body:Node):
	if body.has_method('handle_hit') and body.is_in_group('Player'):
		#agregamos knockback
		var knockback_vector = global_position.direction_to(body.global_position)
		body.handle_hit(knockback_vector)

