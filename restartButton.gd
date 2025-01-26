extends Button
@onready var focus:TextureRect = $focus
# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._restart_pressed)
	
	
func _process(delta: float) -> void:
	if is_hovered():
		focus.visible=true
	if has_focus():
		focus.visible=true
		if Input.is_action_pressed("Accept"):
			_restart_pressed()
	else:
		focus.visible=false
	pass
func _restart_pressed():
	get_tree().reload_current_scene()
