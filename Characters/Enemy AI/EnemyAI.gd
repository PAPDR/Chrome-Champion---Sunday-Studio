extends Resource
class_name EnemyAI

func choose_action(actor: Character_Entity, allies: Array[Character_Entity], opponents: Array[Character_Entity], move_list: Array[Action]) -> Action_Choice:
	return Action_Choice.new()
