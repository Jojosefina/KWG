extends Particles2D


onready var timer = $Timer

func _ready():
	timer.connect("timeout", self, "queue_free")
	timer.wait_time = lifetime
