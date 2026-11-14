extends Node
#Globals has global values stored through the game

enum action_target {
	SELF, #0
	ENEMIES, #1
	ALLIES, #2
	ALL #3
}

func get_action_stat(character: Character_Entity, action: Action) -> float:
	match action.scaling_stat:
		Action.ScalingStat.STRENGTH:
			return character.stat_sheet_instance.Strength
		Action.ScalingStat.DEXTERITY:
			return character.stat_sheet_instance.Dexterity
		Action.ScalingStat.RESISTENCE:
			return character.stat_sheet_instance.Resilience
		Action.ScalingStat.CT:
			return character.stat_sheet_instance.CT
		Action.ScalingStat.NONE:
				return 0.0
	return 0.0

#Basic damage calculation
func damage_calculation(attacker: Character_Entity, defender: Character_Entity, action: Action) -> int:
	var attack_stat  = get_action_stat(attacker, action)
	var multiplier = action.Scaling_multiplier
	
	var defense_stat = defender.stat_sheet_instance.Resilience
	
	var damage = action.base_damage + (attack_stat * multiplier) - defense_stat
	
	return max(roundi(damage), 0)
