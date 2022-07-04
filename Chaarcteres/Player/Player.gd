extends Character

class_name Player 
onready var detection_bar=$CanvasLayer/DetectionBar

#campo de vision
var detection_value=0.0
const MAX_LEVEL_DETECTTION=100

#salud
onready var health_stat= $Salud


#guantazos y balazos



onready var melee_area = $melee
onready var laser= $Arma_Lejana
export(int) var speed=10
var roll_vector=Vector2.LEFT



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

func _physics_process(delta:float)-> void:
	
	_get_input(delta)
	# pa donde mira (ROTA EL MONITO DE DERECHA A IZQUIERDA)
	if Input.is_action_pressed("LEFT") and not Input.is_action_pressed("RIGHT") and facing_right:
		facing_right = not facing_right
		scale.x *= -1
	if Input.is_action_pressed("RIGHT") and not Input.is_action_pressed("LEFT") and not facing_right:
		facing_right = not facing_right
		scale.x *= -1
		
	# rotacion de zona de melee y disparos
	if Input.is_action_pressed("UP") and not Input.is_action_pressed("DOWN"):
		pass
	if Input.is_action_pressed("DOWN") and not Input.is_action_pressed("UP") :
		pass
	velocidad=move_and_slide(velocidad)
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

func _on_melee_area_entered(_body:Node):
	if _body.has_method('handle_hit'):
		_body.handle_hit()
		
	

func _unhandled_input(event: InputEvent)-> void:
	if event.is_action_pressed("shoot"):
		laser.shoot()


func handle_hit():
	health_stat.health-=20
	print('AUCH', health_stat.health)
	if health_stat.health<=0:
		queue_free()
	
