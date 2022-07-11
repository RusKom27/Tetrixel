extends CPUParticles2D

func start_emitting():
	emitting = true

func _physics_process(_delta):
	if emitting == false:
		queue_free()
