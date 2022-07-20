extends Node2D

signal cambio_de_estado(nuevo_estado)

onready var visual= $campo_de_vision
onready var zona_agro=$campo_de_vision
onready var timer_agro=$timer_agro
var facing_rigth=true

#estados
enum State{ PATRULLAR,
	AGRO,
}

var current_state: int= -1 setget set_state
var player: Player = null
var target
var actor: KinematicBody2D=null

#patrullaje
var origin: Vector2=Vector2.ZERO
var lugar_patrullaje: Vector2=Vector2.ZERO
var lugar_patrullaje_llegado: bool=false

func _ready():
	set_state(State.PATRULLAR)


func initialize(new_actor):
	self.actor=new_actor

func _process(delta:float)-> void:
	if not is_instance_valid(actor):
		return 
	match current_state:
		State.PATRULLAR:
				return 
		State.AGRO:
			if is_instance_valid(player):
				#rotación del enemigo cuando llega a cierto a angulo 
				var angulo_jogador=actor.global_position.direction_to(player.global_position).angle()
				#rotaciones de sprite
				if abs(angulo_jogador)>PI/2 and facing_rigth: 
					facing_rigth= not facing_rigth
					actor.sprite.scale.x *= -1
					
				if abs(angulo_jogador)<PI/2 and not facing_rigth: 
					facing_rigth= not facing_rigth
					actor.sprite.scale.x *= -1
				
				#rotacion del arma
				actor.laser.rotation = lerp_angle(actor.laser.rotation, angulo_jogador, 0.1)
				actor.laser.shoot()
				if target:
					player.detection_level(delta)
				
			else:
				actor.velocity = Vector2.ZERO
				set_state(State.PATRULLAR)



func set_state(new_state:int):
	if new_state == current_state:
		return
	if new_state== State.PATRULLAR:
		origin=global_position
		lugar_patrullaje_llegado=false
	
	current_state=new_state
	emit_signal("cambio_de_estado",current_state)

func _on_campo_de_vision_body_entered(body):
	if body.is_in_group("Player"):
		actor.emit_signal('detectar')
		set_state(State.AGRO)
		player=body
		target=true
		timer_agro.stop()

func _on_campo_de_vision_body_exited(body):
	if player and body==player:
		timer_agro.start()
		target=false

func _on_zona_agro_body_exited(body):
	if player and body==player:
		set_state(State.PATRULLAR)
		player=null


func _on_timer_agro_timeout():
	player=null
	set_state(State.PATRULLAR)
