extends Node2D

class_name AI

signal cambio_de_estado(nuevo_estado)

onready var visual= $Campo_de_vision
onready var zona_agro=$zona_de_agro
onready var timer_agro=$tiempo_agro
onready var timer_patrullaje=$tiempo_patrullaje
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

func _physics_process(delta:float)-> void:
	if not is_instance_valid(actor):
		return 
	match current_state:
		State.PATRULLAR:
			if not lugar_patrullaje_llegado:
				var actor_angle= actor.global_position.direction_to(lugar_patrullaje).angle()
				#rotaciones
				if abs(actor_angle)>PI/2 and facing_rigth: 
					facing_rigth= not facing_rigth
					actor.scale.x *= -1
				if abs(actor_angle)<PI/2 and not facing_rigth: 
					facing_rigth= not facing_rigth
					actor.scale.x *= -1
				#persecucion
				actor.move_and_slide(actor.velocity)
				if actor.global_position.distance_to(lugar_patrullaje) < 5:
					lugar_patrullaje_llegado=true
					actor.velocity=Vector2.ZERO
					timer_patrullaje.start()
				
		State.AGRO:
			if player is Player:
				var space_state=get_world_2d().direct_space_state
				var result=space_state.intersect_ray(actor.global_position,player.global_position,[actor])
				if result.collider is Player:
					#persecución
					actor.velocity = (player.global_position-actor.global_position).normalized() * actor.run_speed
					#rotación del enemigo cuando llega a cierto a angulo (pendiente)
					var angulo_jogador=actor.global_position.direction_to(player.global_position).angle()
					#rotaciones
					if abs(angulo_jogador)>PI/2 and facing_rigth: 
						facing_rigth= not facing_rigth
						actor.scale.x *= -1
					if abs(angulo_jogador)<PI/2 and not facing_rigth: 
						facing_rigth= not facing_rigth
						actor.scale.x *= -1
					if target:
						player.detection_level(delta)
				else:
						set_state(State.PATRULLAR)
			else:
				actor.velocity = Vector2.ZERO
				set_state(State.PATRULLAR)
			actor._chase(actor.velocity)

	
func set_state(new_state:int):
	if new_state == current_state:
		return
	if new_state== State.PATRULLAR:
		origin=global_position
		timer_patrullaje.start()
		lugar_patrullaje_llegado=false
	
	current_state=new_state
	emit_signal("cambio_de_estado",current_state)



func _on_Campo_de_vision_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		actor.emit_signal('detectar')
		set_state(State.AGRO)
		player=body
		target=true
		timer_agro.stop()


func _on_Campo_de_vision_body_exited(body):
	if player and body==player:
		timer_agro.start()
		target=false

func _on_zona_de_agro_body_exited(body):
	if player and body==player:
		set_state(State.PATRULLAR)
		player=null
		

func _on_tiempo_agro_timeout():
	player=null
	set_state(State.PATRULLAR)

func _on_tiempo_patrullaje_timeout():
	actor.velocity=Vector2.ZERO
	var rango=50
	var random_x=rand_range(-rango,rango)
	var random_y=rand_range(-rango,rango)
	lugar_patrullaje=Vector2(random_x,random_y) + origin
	lugar_patrullaje_llegado=false
	actor.velocity=actor.global_position.direction_to(lugar_patrullaje)*70
