extends EnemyAI
class_name SampleAI

#Sample AI. Chooses to use "base_attack". If it is not in the array, it uses the first option. If there are
#no first options, chooses "base_attack" anyways
func choose_action(actor: Character_Entity, allies: Array[Character_Entity], opponents: Array[Character_Entity], move_list: Array[Action]) -> Action_Choice:
	for move in move_list:
		if move.name == "Basic Attack":
			var base_action = Action_Choice.new()
			base_action.action = Globals.BASIC_ATTACK
			base_action.target = opponents[0]
			return base_action
	
	if move_list.size() > 0:
		var new_action = Action_Choice.new()
		new_action.action = move_list[0]
		new_action.target = opponents[0]
		return new_action
	
	var base_action = Action_Choice.new()
	base_action.action = Globals.BASIC_ATTACK
	base_action.target = opponents[0]
	return base_action
