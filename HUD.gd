extends CanvasLayer
@onready var healthComponent:HealthComponent = $"../HealthComponent"
@onready var health:Label = $Control/health
@onready var currentWave:Label = $Control/currentWave
@onready var urDeadBro:Label = $Control/urDeadBro
@onready var info:Label = $Control/info

var start:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start = Time.get_unix_time_from_system()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Time.get_unix_time_from_system()-start>5:
		info.visible = false
	health.text = "Health:" + str(healthComponent.health) + "%"
	currentWave.text = "Current wave: " + str(WaveInformation.WaveCount)
	if healthComponent.health <= 0:
		urDeadBro.text = "You died\nYou got to wave " + str(WaveInformation.WaveCount) + "\nPress A/X/Enter to restart"
	pass
