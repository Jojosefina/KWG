extends Node2D

var detected = false
onready var enemies = $Enemigos 
onready var puertas = $Puertas
onready var area =$Area2D
onready var centro = $center

func _ready(): 
	area.connect("body_entered", self, "on_body_enter")

func on_body_enter(body):
	if body.is_in_group("Player"):
		#Conectar señal de enemigos 
		for enemy in enemies.get_children():
			if not enemy.is_connected('death',self,'on_enemy_death'):
				enemy.connect('death',self,'on_enemy_death')
			if not enemy.is_connected('detectar',self,'on_player_detected'):
				enemy.connect('detectar',self,'on_player_detected',[],CONNECT_ONESHOT)
		body.reset_tp()
		#Configurar la cámara
		get_parent().camera.global_position = centro.global_position


func open_door():
	puertas.propagate_call("open")
	
func close_door():
	puertas.propagate_call("close")

func on_enemy_death():
	yield(get_tree().create_timer(1.5),"timeout")
	if enemies.get_child_count()==0:
		open_door()

func on_player_detected():
	if not detected:
		detected=true
		close_door()

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo and event.scancode==KEY_F:
			open_door()
