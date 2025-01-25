extends CharacterBody3D
class_name Player

@export
var camera:Camera3D
@export
var springArm:SpringArm3D

const camMin = -0.7
const camMax = 0.7

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var lastMouse:Vector2

var bAttacking = false

func _ready() -> void:
	#Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED;
	lastMouse = get_viewport().get_mouse_position()
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

	var deltaMouse:Vector2 = get_viewport().get_mouse_position()-lastMouse
	
	if springArm.rotation.x-deltaMouse.y/150>camMin and springArm.rotation.x-deltaMouse.y/150<camMax:
		#camera.rotation.x += -deltaMouse.y/150
		springArm.rotation.x += -deltaMouse.y/150
		
	print(camera.rotation.x)
	#rotation.y += -deltaMouse.x/150
	#camera.rotate(Vector3(1,0,0), -deltaMouse.y/150)
	#springArm.rotate(Vector3(1,0,0), -deltaMouse.y/150)
	springArm.rotation.y += -deltaMouse.x/150
	
	if Input.is_action_just_pressed("light_attack"):
		bAttacking = true
		$Body/WeaponRoot/WeaponModel.show()
		$Body/WeaponRoot.rotation = Vector3(0, -PI/2, 0)
		
	if bAttacking:
		$Body/WeaponRoot.rotate_y(0.2)
		if $Body/WeaponRoot.rotation.y > PI/2:
			bAttacking = true
			$Body/WeaponRoot/WeaponModel.hide()
			
		
	
	lastMouse = get_viewport().get_mouse_position()
	
