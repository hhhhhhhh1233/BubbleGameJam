extends RigidBody3D
@export var speed_exploding_threshold : float = 13.0
@export var fatal_collision_angle : float = 0.5

@export var EnemyScene : PackedScene
@export var poppedScene : PackedScene

var collision_normals : Array[Vector3]




var last_velocity = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initialize(pos, unbubble_time):
	position = pos
	await get_tree().create_timer(unbubble_time).timeout
	unbubble()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	last_velocity = linear_velocity
	
	
func exploded() -> void:
	var pop = poppedScene.instantiate()
	add_sibling(pop)
	pop.position = position
	for enemy in $EnemyDetector.get_overlapping_bodies():
		
		#print("So much soapinesssd: ", (enemy.position - position).length() / 30)
		var detection_radius = 8
		var soapiness_ratio = (detection_radius - (enemy.position - position).length()) / detection_radius
		enemy.get_soaped(soapiness_ratio)
	
	queue_free()
	
func unbubble() -> void:
	var Enemy = EnemyScene.instantiate()
	add_sibling(Enemy)
	Enemy.position = position
	queue_free()

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	for i in state.get_contact_count():
		if state.get_contact_collider_object(i).get_collision_layer_value(5) and linear_velocity.length() > 10:
			#print("Hit something hard!")
			exploded()
		#print(linear_velocity.project(state.get_contact_local_normal(i)).length())
		#pass
		#if linear_velocity.normalized().dot(state.get_contact_local_normal(i)) <= fatal_collision_angle and last_velocity.length() >= speed_exploding_threshold:
			#exploded()
		#
		
func hit_stop(time_scale : float,duration: float):
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration,true,false,true).timeout
	Engine.time_scale = 1
	
