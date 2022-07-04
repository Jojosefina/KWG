extends KinematicBody2D

var SPEED = 100
var ACCELERATION = 500
var GRAVITY = 400

var velocity = Vector2()

onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")
onready var pivot = $Pivot
onready var feet = $Feetlo
onready var melee_area = $Pivot/MeleeArea

var Block = preload("res://scenes/Block.tscn")
var Dust = preload("res://scenes/Dust.tscn")

export var attacking = false


func _ready():
	anim_tree.active = true
	attacking = false
	
	melee_area.connect("body_entered", self, "_on_melee_area_entered")

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var move_input = Input.get_axis("move_left", "move_right")
	
	if attacking:
		move_input = 0
	
	velocity.x = move_toward(velocity.x, move_input * SPEED, ACCELERATION)

	
	velocity.y += GRAVITY * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -2 * SPEED
	
	var melee = false
	if Input.is_action_just_pressed("attack"):
		playback.travel("melee")
		melee = true
	
	
	if Input.is_action_just_pressed("place"):
		_place()
	
	# Animation
	
	if not melee:
		if is_on_floor():
			if abs(velocity.x) > 10:
				playback.travel("run")
			else:
				playback.travel("idle")
		else:
			if velocity.y > 0:
				playback.travel("fall")
			else:
				playback.travel("jump")
	
	# Animation
	if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		pivot.scale.x = 1
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		pivot.scale.x = -1


func land():
	pass
	# var dust = Dust.instance()
	# get_parent().add_child(dust)
	#dust.global_position = feet.global_position

func _on_melee_area_entered(body: Node):
	if body.has_method("take_damage"):
		body.take_damage(self)


func _place():
	var block = Block.instance()
	get_parent().add_child(block)
	block.global_position = get_global_mouse_position()
