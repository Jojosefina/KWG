extends RigidBody2D


func take_damage(instigator: Node2D):
	apply_central_impulse((global_position - instigator.global_position).normalized() * 200)
