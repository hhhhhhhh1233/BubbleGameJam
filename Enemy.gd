extends CharacterBody3D

var pos : Basis
var speed : float = 10
var accel : float = 5
var direction : Vector3

@onready var nav: NavigationAgent3D = $NavigationAgent3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pos = get_global_transform().basis
	$Body.look_at(Vector3(direction.x, global_position.y, direction.z))
	pass

func _physics_process(delta: float) -> void:
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()
