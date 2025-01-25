extends NavigationAgent3D

@onready var player : CharacterBody3D
@onready var aggroCollision : Area3D = $AggroCollision
var overlappingBodies : Array[Node3D]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	overlappingBodies = aggroCollision.get_overlapping_bodies()
	if overlappingBodies.size() != 0:
		self.target_position = overlappingBodies[0].global_position
		#print(overlappingBodies.size())
	#print(target_position)
	pass
	
func _physics_process(delta: float) -> void:
	get_next_path_position()
