extends Control
@onready var startButton:Button = $ColorRect/Play
@onready var startButtonFocus:TextureRect = $ColorRect/Play/TextureRect

@onready var quitButton:Button = $ColorRect/Quit
@onready var quitButtonFocus:TextureRect = $ColorRect/Quit/TextureRect

@onready var pivot:Control = $ColorRect/logo/pivot


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	startButton.pressed.connect(self._start_pressed)
	quitButton.pressed.connect(self._quit_pressed)
	startButton.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pivot.rotation -= 0.2*delta
	if startButton.is_hovered() or startButton.has_focus():
		startButtonFocus.visible=true
		if Input.is_action_pressed("Accept"):
			_start_pressed()
	else:
		startButtonFocus.visible=false
	
	if quitButton.is_hovered() or quitButton.has_focus():
		quitButtonFocus.visible=true
		if Input.is_action_pressed("Accept"):
			_quit_pressed()
	else:
		quitButtonFocus.visible=false
	
		
	pass

func _start_pressed() -> void:
	get_tree().change_scene_to_file("res://real_level.tscn")
	pass
func _quit_pressed() -> void:
	get_tree().quit(0)
	pass
