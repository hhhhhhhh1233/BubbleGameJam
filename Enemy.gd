extends CharacterBody3D
var pos : Basis
var speed : float = 7
var accel : float = 5
var direction : Vector3
@export var aggroCollision : Area3D
@onready var nav: NavigationAgent3D = $NavigationAgent3D
var overlappingBodies : Array[Node3D]
@export var hitrange = 5
#@export var hitvisualizer : MeshInstance3D

var whackDelay = 0.3
var whackCooldown = 1
var whackDamage = 20
var canWhack:bool
var soapiness = 0.0
var maxSoapiness = 1.0
var whacking:bool
var whackLast:float
var whackStart:float
var playerHealthComponent:HealthComponent
var playerToWhack:Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	whackLast = Time.get_unix_time_from_system()
	#hitvisualizer.position=Vector3(0,0,0)
	#hitvisualizer.scale=Vector3(hitrange, hitrange, hitrange)
	pass # Replace with function body.

func whack(player: Player)->void:
	canWhack=false
	$Body/AnimationTree["parameters/attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	whackLast = Time.get_unix_time_from_system()
	#hitvisualizer.visible=true
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
	
	if whacking:
		if Time.get_unix_time_from_system() >= whackStart + whackDelay:
			whack(playerToWhack)
			whacking=false
		return
	
	#hitvisualizer.visible=false
	pos = get_global_transform().basis
	$Body.look_at($Body.global_position - Vector3(direction.x, 0, direction.z))
	overlappingBodies = aggroCollision.get_overlapping_bodies()
	if overlappingBodies.size() != 0:
		
		if (overlappingBodies[0].global_position - global_position).length()<hitrange*0.5 :
			direction = nav.get_next_path_position() - global_position
			direction = direction.normalized()
			playerToWhack = overlappingBodies[0]
			if canWhack:
				whacking = true
				whackStart = Time.get_unix_time_from_system()
		
		else:
			direction = nav.get_next_path_position() - global_position
			direction = direction.normalized()
			
		if !canWhack:
			velocity = velocity.lerp(direction * speed * 0.3, accel * delta)
		else:
			velocity = velocity.lerp(direction * speed, accel * delta)
		
	$Body/AnimationTree["parameters/speed/blend_amount"] = min(velocity.length(),1)
	move_and_slide()
	
	if Time.get_unix_time_from_system() - whackLast > whackCooldown:
		canWhack=true
	
	pass

func get_soaped(deltaSoap : float):
	soapiness = soapiness + deltaSoap
	
	if soapiness >= maxSoapiness:
		soapiness = maxSoapiness
		bubble()
	$GPUParticles3D.amount_ratio = soapiness

func bubble():
	var EnemyPosition = position
	var BubbledEnemy = load("res://bubbled_enemy.tscn").instantiate()
	add_sibling(BubbledEnemy)
	BubbledEnemy.initialize(EnemyPosition, 3)
	queue_free()

#func _physics_process(delta: float) -> void:
