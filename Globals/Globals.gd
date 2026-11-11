extends Node
#Globals has global values stored through the game

enum action_target {
	SELF, #0
	ENEMIES, #1
	ALLIES, #2
	ALL #3
}

#Basic damage calculation
func damage_calculation(attacker: Character_Entity, defender: Character_Entity, action: Action) -> int:
	return max(attacker.Strength - defender.Resilience, 0)
