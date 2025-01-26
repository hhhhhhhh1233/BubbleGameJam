extends GPUParticles3D

var Health_pickup = preload("res://health_pickup.tscn")
var randomised : bool = false
var spawned_heal : bool = false
var rand_drop : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	emitting = true
	if !$BubblePopSound.playing:
		$BubblePopSound.play()
	await get_tree().create_timer(0.5).timeout
	emitting = false
	if !randomised:
		rand_drop = randi_range(0,4)
		randomised = true
	if rand_drop >= 3 && !spawned_heal:
		spawned_heal = true
		_drop_heal()
	else:
		await $BubblePopSound.finished
		queue_free()
func _drop_heal():
	var pickup = Health_pickup.instantiate()
	add_sibling(pickup)
	pickup.global_position = global_position
	await $BubblePopSound.finished
	queue_free()
