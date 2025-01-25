extends CharacterBody3D
var pos : Basis
var speed : float = 7
var accel : float = 5
var direction : Vector3
@export var aggroCollision : Area3D
@onready var nav: NavigationAgent3D = $NavigationAgent3D
var overlappingBodies : Array[Node3D]
@export var hitrange = 5
@export var hitvisualizer : MeshInstance3D

var whackDelay = 1
var whackDamage = 20
var canWhack:bool
var whackLast:float
var playerHealthComponent:HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	whackLast = Time.get_unix_time_from_system()
	hitvisualizer.position=Vector3(0,0,0)
	hitvisualizer.scale=Vector3(hitrange, hitrange, hitrange)
	pass # Replace with function body.

func whack(player: Player)->void:
	canWhack=false
	whackLast = Time.get_unix_time_from_system()
	hitvisualizer.visible=true
	if playerHealthComponent == null:
		for child in player.get_children():
			if child is HealthComponent:
				playerHealthComponent = child as HealthComponent
				break
	playerHealthComponent.Damage(whackDamage)
	#print(playerHealthComponent.health)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hitvisualizer.visible=false
	pos = get_global_transform().basis
	$Body.look_at(Vector3(direction.x, global_position.y, direction.z))
	overlappingBodies = aggroCollision.get_overlapping_bodies()
	if overlappingBodies.size() != 0:
		
		if (overlappingBodies[0].global_position - global_position).length()<hitrange*0.5 :
			direction = nav.get_next_path_position() - global_position
			direction = direction.normalized()
			
			if canWhack:
				whack(overlappingBodies[0])
		
		else:
			direction = nav.get_next_path_position() - global_position
			direction = direction.normalized()
			
		if !canWhack:
			velocity = velocity.lerp(direction * speed * 0.3, accel * delta)
		else:
			velocity = velocity.lerp(direction * speed, accel * delta)
		
	move_and_slide()
	
	if Time.get_unix_time_from_system() - whackLast > whackDelay:
		canWhack=true
	
	pass

#func _physics_process(delta: float) -> void:
