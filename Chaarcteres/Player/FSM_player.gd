extends FiniteStateMachine

#func _init():
#	_add_state("IdleCat")
#	_add_state("Run")

#func _ready()-> void:
#	set_state(states.IdleCat)

#func _state_logic(_delta: float)-> void:
#	parent._get_input()
#	parent.move()
	

#func _get_transition()-> int:
#	match state:
#		states.IdleCat:
#			if parent.velocidad.length()> 10:
#				return states.Run
#		states.Run:
#			if parent.velocidad.length()<10:
#				return states.IdleCat
#	return -1
#func _enter_state(_previous_state: int, _new_state: int)-> void:
	#match _new_state:
		#if parent.velocidad.length()> 10:
		#	animation_player.play("IdleCat")
		#if parent.velocidad.length()<10:
		#	animation_player.play("Run")
