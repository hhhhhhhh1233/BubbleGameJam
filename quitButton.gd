extends Button
@onready var focus:TextureRect = $focus

func _ready():
	self.pressed.connect(self._quit_pressed)
	
func _process(delta: float) -> void:
	if is_hovered() :
		focus.visible=true
	if has_focus():
		focus.visible=true
		if Input.is_action_pressed("Accept"):
			_quit_pressed()
	else:
		focus.visible=false
	pass
func _quit_pressed():
	
	get_tree().quit(0)
