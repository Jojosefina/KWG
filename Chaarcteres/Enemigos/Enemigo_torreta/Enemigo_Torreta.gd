extends KinematicBody2D

var facing_right = true
var facing_down= true
var hurt=false
onready var PLAYBACK = $AnimationTree.get("parameters/playback")
onready var tween_knockback=$tween_knockback
onready var tween_modulate=$tween_modulate
onready var animation_player=$AnimationPlayer
onready var sprite=$Sprite
# fisicas
var run_speed = 60
var velocity = Vector2.ZERO
var path: PoolVector2Array
var knockback_vector=Vector2.ZERO
var knockback_force = 320

#disparos
onready var laser=$Laser


#ai
onready var ai=$AI_torreta
#persecucion y ataques
onready var timer_agro= $tiempo_agro
onready var visual=$AI_torreta/campo_de_vision
onready var zona_agro=$AI_torreta/campo_de_vision
onready var melee_area=$melee_area

#salud
onready var health_stat= $Salud
onready var barra_salud=$HealthBar/HealthBar
onready var escena_muerte=preload("res://Chaarcteres/Enemigos/Enemigo_torreta/death_node_turet.tscn")
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
#		PLAYBACK.travel("run")
#		if ai.current_state==ai.State.AGRO:
#			PLAYBACK.travel("agro")
			pass
	else:
		PLAYBACK.travel("Idle")

func handle_hit(knockback:Vector2):
	health_stat.health-=20
	barra_salud.value=health_stat.health
	if health_stat.health <=0:
		if health_stat.health <=0:
			var death_escene=escena_muerte.instance()
			get_parent().add_child(death_escene)
			if not ai.facing_rigth:
				death_escene.mirror()
			death_escene.set_deferred('global_position',global_position)
		queue_free()
	#modulacion de color
	tween_modulate.interpolate_property(self,'modulate',Color.red,Color.white, 1,Tween.TRANS_SINE,Tween.EASE_OUT)
	tween_modulate.start()
	
