extends FiniteStateMachine
func _init():
	_add_state("idle")
	_add_state("run")

func _ready()-> void:
	set_state(states.idle)

func _state_logic(_delta: float)-> void:
	parent._physics_process()
	

func _get_transition()-> int:
	match state:
		states.idle:
			if parent.velocity.length()> 10:
				return states.run
		states.run:
			if parent.velocity.length()<10:
				return states.idle
	return -1
func _enter_state(_previous_state: int, _new_state: int)-> void:
	match _new_state:
		states.idle:
			animation_player.play("IdleCat")
		states.run:
			animation_player.play("Run")
