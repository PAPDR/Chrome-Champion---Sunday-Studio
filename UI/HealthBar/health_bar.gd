extends VBoxContainer
class_name CombatHealthBar

@export var hp_bar : ProgressBar
@export var name_label : Label


func setup(character: Character_Entity) -> void:
	var combatant : stat_sheet = character.stat_sheet_instance
	name_label.text = combatant.get_character_name()
	update_health(combatant.hp, combatant.Max_HP)
	combatant.health_change.connect(update_health)


func update_health(max_hp: int,hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp
