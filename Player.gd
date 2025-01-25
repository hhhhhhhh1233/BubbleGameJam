extends CharacterBody3D
class_name Player

@export
var camera:Camera3D
@export
var springArm:SpringArm3D

const camMin = -0.7
const camMax = 0.7
const sensitivity = 0.03


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var bAttacking = false
var bLightAttack = false

func _ready() -> void:
	#Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED;
	pass

func _physics_process(delta: float) -> void:
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := Vector3($SpringArm3D.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		$Body.look_at(position - Vector3(direction.x, 0, direction.z))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	var input_camera := Input.get_vector("camera_left", "camera_right", "camera_forward", "camera_back")
	
	if springArm.rotation.x-input_camera.y*sensitivity>camMin and springArm.rotation.x-input_camera.y*sensitivity<camMax:
		#camera.rotation.x += -input_camera.y*sensitivity
		springArm.rotation.x += -input_camera.y*sensitivity
		
	#rotation.y += -input_camera.x*sensitivity
	#camera.rotate(Vector3(1,0,0), -input_camera.y*sensitivity)
	#springArm.rotate(Vector3(1,0,0), -input_camera.y*sensitivity)
	springArm.rotation.y += -input_camera.x*sensitivity
	
	if Input.is_action_just_pressed("light_attack"):
		bAttacking = true
		bLightAttack = true
		$Body/WeaponRoot/WeaponModel.show()
		$Body/WeaponRoot.rotation = Vector3(0, -PI/2, 0)
		
	if Input.is_action_just_pressed("heavy_attack"):
		bAttacking = true
		bLightAttack = false
		$Body/WeaponRoot/HeavyWeaponModel.show()
		$Body/WeaponRoot.rotation = Vector3(0, -PI/2, 0)
		
	if bAttacking:
		if bLightAttack:
			for enemy in $Body/WeaponRoot/WeaponHitbox.get_overlapping_bodies():
				print(enemy)
		else:
			for enemy in $Body/WeaponRoot/HeavyWeaponHitbox.get_overlapping_bodies():
				print(enemy)
		
		$Body/WeaponRoot.rotate_y(0.2)
		if $Body/WeaponRoot.rotation.y > PI/2:
			bAttacking = false
			$Body/WeaponRoot/WeaponModel.hide()
			$Body/WeaponRoot/HeavyWeaponModel.hide()
