extends CanvasLayer
@onready var healthComponent:HealthComponent = $"../HealthComponent"
@onready var health:Label = $Control/health
@onready var currentWave:Label = $Control/currentWave
@onready var urDeadBro:Label = $Control/urDeadBro


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health.text = "Health:" + str(healthComponent.health) + "%"
	currentWave.text = "Current wave: " + str(WaveInformation.WaveCount)
	if healthComponent.health <= 0:
		urDeadBro.text = "UR DEAD BRO"
	pass
