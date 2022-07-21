extends Node2D

onready var bullet_manager=$BulletManager
onready var player=$Player
onready var defeat_popup = $defeat_popup
onready var victory_popup = $victory_popup
onready var door_area = $door_area
onready var camera = $Camera2D
func _ready():
	randomize()
	SenalesGlobales.connect('disparo',bullet_manager,'handle_bullet_spawned')
	player.connect("defeat", defeat_popup, "activate")
	door_area.connect("win", victory_popup, "activate")
	
