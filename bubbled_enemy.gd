extends RigidBody3D
@export var speed_exploding_threshold : float = 13.0
@export var fatal_collision_angle : float = 0.5


var collision_normals : Array[Vector3]

var last_velocity = Vector3()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	
	
	last_velocity = linear_velocity
func exploded() -> void:
	queue_free()

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	for i in state.get_contact_count():
		print(last_velocity.length())
		if linear_velocity.normalized().dot(state.get_contact_local_normal(i)) <= fatal_collision_angle and last_velocity.length() >= speed_exploding_threshold:
			exploded()
		
	
func _on_body_entered(body: Node) -> void:
	
	var collision_direction = (body.global_position - global_position).normalized()
	if linear_velocity.normalized().dot(-collision_direction.normalized()) >= fatal_collision_angle:
		pass


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	pass
