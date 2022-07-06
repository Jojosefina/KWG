extends Node2D


export (int) var MAX_HEALTH=100
export (int) var health=MAX_HEALTH setget set_health

func set_health(new_health:int):
	health=clamp(new_health,0,MAX_HEALTH)
