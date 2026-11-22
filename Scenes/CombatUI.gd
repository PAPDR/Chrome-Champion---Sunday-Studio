extends CanvasLayer

@onready var action_panel: Control = $ActionPanel

func show_action_panel():
	action_panel.visible = true

func hide_action_panel():
	action_panel.visible = false
	
func _ready():
	hide_action_panel()
