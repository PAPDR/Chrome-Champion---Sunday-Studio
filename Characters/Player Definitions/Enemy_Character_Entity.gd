@tool
extends Character_Entity
class_name  Enemy_Character_Entity

#Handles the sprite being clicked
func on_selection_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		SignalBus.target_selected.emit(stat_sheet_instance)
