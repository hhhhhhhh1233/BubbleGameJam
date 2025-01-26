extends CanvasLayer
@onready var healthComponent:HealthComponent = $"../HealthComponent"
@onready var health:Label = $Control/health
@onready var currentWave:Label = $Control/currentWave
@onready var urDeadBro:Label = $Control/urDeadBro
@onready var info:Label = $Control/info
@onready var deathscreen:TextureRect = $Control/death

@onready var restartButton:Button = $Control/restartButton
@onready var quitButton:Button = $Control/quitButton

var deadLastFrame = true


var start:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start = Time.get_unix_time_from_system()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if healthComponent.health <= 0:
		if !deadLastFrame:
			restartButton.grab_focus()
			Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
			deathscreen.visible = true
			health.text = ""
			currentWave.text = ""
			restartButton.set_disabled(false)
			restartButton.visible=true
			quitButton.set_disabled(false)
			quitButton.visible=true
			deadLastFrame=true
		#urDeadBro.text = "You died\nYou got to wave " + str(WaveInformation.WaveCount) + "\nPress A/X/Enter to restart"
	else:
		if deadLastFrame:
			deadLastFrame=false
			deathscreen.visible = false
			Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
			restartButton.set_disabled(true)
			restartButton.visible=false
			quitButton.set_disabled(true)
			quitButton.visible=false
		if Time.get_unix_time_from_system()-start>5:
			info.visible = false
		health.text = "Health:" + str(healthComponent.health) + "%"
		currentWave.text = "Current wave: " + str(WaveInformation.WaveCount)
	
	
	pass
