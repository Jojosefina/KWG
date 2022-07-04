extends KinematicBody2D

class_name Character


var lin_vel: Vector2 = Vector2.ZERO
var velocidad: Vector2= Vector2.ZERO



export var RUNSPEED = 100
export var RUNACCEL = 15
export var FRIC = 30
var facing_right = true
onready var PLAYBACK = $AnimationTree.get("parameters/playback")


func _physics_process(_delta: float)-> void:
	velocidad=move_and_slide(velocidad)
	velocidad=lerp(velocidad, Vector2.ZERO, FRIC)

func move()-> void:
	lin_vel=lin_vel.normalized()
	velocidad+=lin_vel*RUNACCEL

