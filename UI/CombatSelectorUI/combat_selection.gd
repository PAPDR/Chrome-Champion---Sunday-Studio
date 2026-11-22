extends Control

@onready var action_description = $ActionDescription


func _ready():
	SignalBus.hovering_button.connect(on_hover_button)
	SignalBus.exit_hover_button.connect(on_exit_hover_button)

func on_hover_button(button : Action_Button):
	action_description.text = button.hover_description
	pass

func on_exit_hover_button(button : Action_Button):
	SignalBus.action_button_press.emit()
	pass
