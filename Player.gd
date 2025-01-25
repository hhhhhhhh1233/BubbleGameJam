extends CharacterBody3D
class_name Player

@export var camera:Camera3D
@export var springArm:SpringArm3D
@export var bubbleHitForceMultiplier = 35
@export var hitstopScale = 0.01
@export var hitstopDuration = 0.5
@export var healthComponent:HealthComponent


@export var BubbledEnemyScene : PackedScene

const camMin = -1.1
const camMax = 0.7
const sensitivity = 0.06
const sensitivityMouse = 0.01
const character_rotation_speed = 0.2

var lastMouse:Vector2
	

const SPEED = 10.0
const JUMP_VELOCITY = 12

#var bAttacking = false
#var bLightAttack = false

func _ready() -> void:
	#Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED;
	lastMouse = get_viewport().get_mouse_position()
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
	if healthComponent.health <= 0:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		$Body/AnimationTree["parameters/grounded/blend_amount"] = 0.0
	else:
		$Body/AnimationTree["parameters/grounded/blend_amount"] = 1.0
		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Body/AnimationTree["parameters/jump/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := Vector3($SpringArm3D.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		$Body.look_at(position - Vector3(direction.x, 0, direction.z))
		#var target = ($Body.position - Vector3(direction.x, 0, direction.z))
		#$Body.transform.basis.slerp(look_dir.basis, 0.2)
		#var T=$Body.global_transform.looking_at(target.global_transform.origin, Vector3(0,1,0))
		#$Body.global_transform.basis.y=lerp($Body.global_transform.basis.y, T.basis.y, delta*character_rotation_speed)
		#$Body.global_transform.basis.x=lerp($Body.global_transform.basis.x, T.basis.x, delta*character_rotation_speed)
		#$Body.global_transform.basis.z=lerp($Body.global_transform.basis.z, T.basis.z, delta*character_rotation_speed)
		#$Body.look_at(look_dir)
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	
		
		

	$Body/AnimationTree["parameters/speed/blend_amount"] = lerpf(-1,1,direction.length())
	move_and_slide()

	var input_camera := Input.get_vector("camera_left", "camera_right", "camera_forward", "camera_back")
	var deltaMouse = get_viewport().get_mouse_position() - lastMouse
	lastMouse = get_viewport().get_mouse_position()
	
	if springArm.rotation.x-input_camera.y*sensitivity>camMin and springArm.rotation.x-input_camera.y*sensitivity<camMax:
		#camera.rotation.x += -input_camera.y*sensitivity
		springArm.rotation.x += -input_camera.y*sensitivity
		
	if springArm.rotation.x-deltaMouse.y*sensitivityMouse>camMin and springArm.rotation.x-deltaMouse.y*sensitivityMouse<camMax:
		springArm.rotation.x += -deltaMouse.y*sensitivityMouse
		
	#rotation.y += -input_camera.x*sensitivity
	#camera.rotate(Vector3(1,0,0), -input_camera.y*sensitivity)
	#springArm.rotate(Vector3(1,0,0), -input_camera.y*sensitivity)
	springArm.rotation.y += -input_camera.x*sensitivity
	springArm.rotation.y += -deltaMouse.x*sensitivityMouse
	
	
	if Input.is_action_just_pressed("light_attack"):
		if not $Body/AnimationTree["parameters/attack/active"]:
			$Body/AnimationTree["parameters/attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		for enemy in $Body/WeaponRoot/WeaponHitbox.get_overlapping_bodies():
			enemy.bubble()
				#var EnemyPosition = enemy.position
				#var BubbledEnemy = BubbledEnemyScene.instantiate()
				#enemy.add_sibling(BubbledEnemy)
				#enemy.queue_free()
				#BubbledEnemy.initialize(EnemyPosition, 3)
				#BubbledEnemy.position = EnemyPosition
				#print(enemy)
		#bAttacking = true
		#bLightAttack = true
		#$Body/WeaponRoot/WeaponModel.show()
		#$Body/WeaponRoot.rotation = Vector3(0, -PI/2, 0)
		
	if Input.is_action_just_pressed("heavy_attack"):
		if not $Body/AnimationTree["parameters/kick/active"]:
			$Body/AnimationTree["parameters/kick/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
			
		for enemy in $Body/WeaponRoot/HeavyWeaponHitbox.get_overlapping_bodies():
				
				if enemy.get_collision_layer_value(4):
					hitstop(hitstopScale,hitstopDuration)
					var hit_direction = (enemy.global_position - global_position).normalized()
					enemy.linear_velocity = Vector3()
					enemy.apply_central_impulse(hit_direction * bubbleHitForceMultiplier )
					print(enemy)
		#bAttacking = true
		#bLightAttack = false
		#$Body/WeaponRoot/HeavyWeaponModel.show()
		#$Body/WeaponRoot.rotation = Vector3(0, -PI/2, 0)
		
	#if bAttacking:
		#if bLightAttack:
			#for enemy in $Body/WeaponRoot/WeaponHitbox.get_overlapping_bodies():
				#var EnemyPosition = enemy.position
				#enemy.queue_free()
				#var BubbledEnemy = BubbledEnemyScene.instantiate()
				#BubbledEnemy.position = EnemyPosition
				#add_sibling(BubbledEnemy)
				##print(enemy)
		#else:
			#for enemy in $Body/WeaponRoot/HeavyWeaponHitbox.get_overlapping_bodies():
				#print("yep")
				#if enemy.get_collision_layer_value(4):
					#hitstop(0.01,0.5)
					#var hit_direction = (enemy.global_position - global_position).normalized()
					#enemy.apply_central_impulse(hit_direction * bubbleHitForceMultiplier )
					#print(enemy)
		#
		#$Body/WeaponRoot.rotate_y(40 * delta)
		#if $Body/WeaponRoot.rotation.y > PI/2:
			#bAttacking = false
			#$Body/WeaponRoot/WeaponModel.hide()
			#$Body/WeaponRoot/HeavyWeaponModel.hide()
			
func hitstop (timeScale : float, duration : float):
	Engine.time_scale =  timeScale
	$Body/AnimationTree["parameters/kick_time/scale"] = 1/ hitstopScale
	await get_tree().create_timer(duration,true,false,true).timeout
	$Body/AnimationTree["parameters/kick_time/scale"] = 2
	Engine.time_scale = 1.0
	
	
	
	
	
