extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var overlapping_entities = get_overlapping_bodies()
	for i in overlapping_entities:
		if i is Player:
			i.healthComponent.health = 0
	pass
