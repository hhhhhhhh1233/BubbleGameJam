extends Button
# Called when the node enters the scene tree for the first time.
func _ready():
	var button = Button.new()
	button.text = "Quit"
	button.pressed.connect(self._button_pressed)
	add_child(button)

func _button_pressed():
	get_tree().quit(0)
