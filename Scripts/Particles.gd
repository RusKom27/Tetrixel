extends CPUParticles2D

func start_emitting():
	emitting = true

func _physics_process(delta):
	if emitting == false:
		queue_free()
