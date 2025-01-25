extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	emitting = true
	await get_tree().create_timer(0.5).timeout
	emitting = false
	await get_tree().create_timer(1.0).timeout
	queue_free()
