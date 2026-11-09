extends Node
#Globals has global values stored through the game

#Basic damage calculation
func damage_calculation(attacker: Character_Entity, defender: Character_Entity, action: Action) -> int:
	return max(attacker.Strength - defender.Resilience, 0)
