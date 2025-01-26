extends GPUParticles3D

var Health_pickup = preload("res://health_pickup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	emitting = true
	await get_tree().create_timer(0.5).timeout
	emitting = false
	await get_tree().create_timer(1.0).timeout
	var pickup = Health_pickup.instantiate()
	add_sibling(pickup)
	pickup.global_position = global_position
	queue_free()
