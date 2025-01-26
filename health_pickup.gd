extends RigidBody3D

var SPEED = 5
var healing = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for player in $Area3D.get_overlapping_bodies():
		linear_velocity += Vector3(player.global_position - global_position) * SPEED




func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.healthComponent.Heal(healing)
		queue_free()
