extends Node
#Globals has global values stored through the game

const BASIC_ATTACK = preload("uid://cm73dkx4gjvik")

func create_action_choice(action: Action, choice: Character_Entity):
	var new = Action_Choice.new()
	new.action = action
	new.target = choice
	return new

enum action_target {
	SELF, #0
	ENEMIES, #1
	ALLIES, #2
	ALL #3
}

#Basic damage calculation
func damage_calculation(attacker: Character_Entity, defender: Character_Entity, action: Action) -> int:
	return max(attacker.Strength - defender.Resilience, 0)
