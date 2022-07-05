extends KinematicBody2D

class_name Player 
onready var detection_bar=$CanvasLayer/DetectionBar
onready var tp_scn = preload("res://escenas/Armas y manejo/tp_sprite.tscn")
onready var tp_node = $tp

#fisicas
var lin_vel: Vector2 = Vector2.ZERO
var velocidad: Vector2= Vector2.ZERO
export var RUNSPEED = 100
export var RUNACCEL = 15
export var FRIC = 30
var knockback_vector=Vector2.ZERO
var knockback_force = 160
var tps = 3
var tp_on = false
var tp_mark = null

#animaciones
var facing_right = true
var facing_down= true
onready var PLAYBACK = $AnimationTree.get("parameters/playback")

#campo de vision
var detection_value=0.0
const MAX_LEVEL_DETECTTION=100

#salud
onready var health_stat= $Salud

#guantazos y balazos
onready var melee_area = $melee
onready var laser= $Arma_Lejana
export(int) var speed=10


#funciones
func _ready():
	$AnimationTree.active = true
	detection_bar.max_value=MAX_LEVEL_DETECTTION
	melee_area.connect("body_entered", self, "_on_melee_area_entered")

# Cosa de deteccion
func _process(_delta):
	detection_bar.value=detection_value

func detection_level(delta):
	detection_value+=40*delta
	detection_bar.value=detection_value

#movimiento

func _get_input(delta):
	#var input_vector=Vector2.ZERO
	var target_velX = (Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT"))
	var target_velY = (Input.get_action_strength("DOWN") - Input.get_action_strength("UP"))
	lin_vel = move_and_slide(lin_vel)
	
	#input_vector.x=target_velX
	#input_vector.y=target_velY
	
	#melee_area.knockback_vector=input_vector
	if PLAYBACK.get_current_node() == "basic_attack":
		target_velX = 0
		target_velY = 0
		
	# VELOCIDAD EN X
	if target_velX != 0:
		lin_vel.x = lerp(lin_vel.x, target_velX * RUNSPEED, RUNACCEL * delta)
	else:
		lin_vel.x = lerp(lin_vel.x, 0, FRIC *delta)
	
	# VELOCIDAD EN Y
	if target_velY != 0:
		lin_vel.y = lerp(lin_vel.y, target_velY * RUNSPEED, RUNACCEL * delta)
	else:
		lin_vel.y = lerp(lin_vel.y, 0, FRIC * delta)

func _physics_process(delta):
	
	_get_input(delta)
	#knockback
	knockback_vector=knockback_vector.move_toward(knockback_vector,knockback_force*delta)
	knockback_vector=lerp(knockback_vector,Vector2.ZERO, delta)
	move_and_slide(knockback_vector)
	# pa donde mira (ROTA EL MONITO DE DERECHA A IZQUIERDA)
	if Input.is_action_pressed("LEFT") and not Input.is_action_pressed("RIGHT") and facing_right:
		facing_right = not facing_right
		scale.x *= -1
	if Input.is_action_pressed("RIGHT") and not Input.is_action_pressed("LEFT") and not facing_right:
		facing_right = not facing_right
		scale.x *= -1
	#rotar area melee hacia arriba y arma
	if Input.is_action_pressed("UP") and not Input.is_action_pressed("DOWN") :
		#melee_area.global_rotation_degrees=90
		#laser.global_rotation_degrees=90
		pass
	if Input.is_action_pressed("DOWN") and not Input.is_action_pressed("UP") :
		#melee_area.global_rotation_degrees=-90
		#laser.global_rotation_degrees=-90
		pass
	velocidad=move_and_slide(velocidad)
	
	if Input.is_action_just_pressed("TP"):
		# cuando esta puesto el tp
		if tp_on:
			tp_on = false
			if is_instance_valid(tp_mark):
				global_position = tp_mark.global_position
				tp_mark.queue_free()
				
		# aun no se pone el tp
		elif tps > 0:
			tp_on = true
			tp_mark = tp_scn.instance()
			tps -= 1
			tp_node.add_child(tp_mark)
			tp_mark.global_position = global_position
			
			
	#animaciones
	var attacking = false
	if Input.is_action_just_pressed("melee"):
		print("golpe")
		PLAYBACK.travel("basic_attack")
		attacking = true
	if not attacking:
		if lin_vel.length() >= 10:
			PLAYBACK.travel("Run")
		else:
			PLAYBACK.travel("IdleCat")

func _on_melee_area_entered(body:Node):
	if body.has_method('handle_hit'):
		#agregamos knockback
		var knockback_vector = global_position.direction_to(body.global_position)
		body.handle_hit(knockback_vector)


func _unhandled_input(event: InputEvent)-> void:
	if event.is_action_pressed("shoot"):
		laser.shoot()


func handle_hit(knockback:Vector2):
	health_stat.health-=20
	print('AUCH', health_stat.health)
	if health_stat.health<=0:
		queue_free()
	knockback_vector=knockback*knockback_force

func reset_tp():
	tps = 3
	
	
