extends KinematicBody2D


var facing_right = true
var facing_down= true
var hurt=false

signal death
signal detectar


onready var escena_muerte=preload("res://Chaarcteres/Enemigos/Enemigo_Dog/death_node.tscn")
onready var PLAYBACK = $AnimationTree.get("parameters/playback")
onready var tween_knockback=$tween_knockback
onready var tween_modulate=$tween_modulate
onready var animation_player=$AnimationPlayer
onready var tween_jump=$tween_jump

# fisicas
var run_speed = 60
var velocity = Vector2.ZERO
var path: PoolVector2Array
var knockback_force = 320
var jump_force =7.15
#ai
onready var ai=$AI_dog


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

func _physics_process(_delta):
	#animaciones
	if velocity.length() >= 2:
		PLAYBACK.travel("run")
		if ai.current_state==ai.State.AGRO:
			PLAYBACK.travel("Agro")
	else:
		PLAYBACK.travel("Idle")

func jump(vector:Vector2):
	vector=vector*jump_force
	tween_knockback.interpolate_method(self,'move_and_slide',vector,Vector2.ZERO, 1, Tween.TRANS_QUINT,Tween.EASE_OUT)
	tween_knockback.start()
	PLAYBACK.travel("jump")


func _chase(new_velocity):
	move_and_slide(new_velocity)

func handle_hit(knockback:Vector2):
	health_stat.health-=20
	barra_salud.value=health_stat.health
	if health_stat.health <=0:
		emit_signal("death")
		var death_escene=escena_muerte.instance()
		get_parent().add_child(death_escene)
		if not ai.facing_rigth:
			death_escene.mirror()
		death_escene.set_deferred('global_position',global_position)
		queue_free()
	ai.set_state(ai.State.AGRO)
	#knockback
	var knockback_vector=knockback*knockback_force
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

