extends Node2D

var detected = false
onready var enemys = $Enemigos 
onready var puertas = $Puertas
onready var area =$Area2D

func _ready(): 
	area.connect("body_entered", self, "on_body_enter")

func on_body_enter(body):
	if body.is_in_group("Player"):
		#Conectar señal de enemigos 
		#Configurar la cámara
		pass 
		
func open_door():
	puertas.propagate_call("open")
	
func close_door():
	puertas.propagate_call("close")
	
