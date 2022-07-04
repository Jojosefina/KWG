extends Node2D

onready var bullet_manager=$BulletManager
onready var player=$Player

func _ready():
	randomize()
	SenalesGlobales.connect('disparo',bullet_manager,'handle_bullet_spawned')

