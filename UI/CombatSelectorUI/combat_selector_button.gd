extends Button
class_name Action_Button

@export var hover_description : String



func _on_mouse_entered():
	SignalBus.hovering_button.emit(self)
	pass # Replace with function body.


func _on_mouse_exited():
	SignalBus.exit_hover_button.emit(self)
	pass # Replace with function body.




func _on_pressed():
	SignalBus.action_button_press.emit()
	pass # Replace with function body.
