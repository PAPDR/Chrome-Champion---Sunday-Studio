extends Resource
class_name stat_sheet



#CHARACTER DEFINITION----
@export var CharacterName : String
@export var headshot : Texture
@export var sprite : Texture
@export var enemyAI : EnemyAI
@export var move_list : Array[Action]
@export var cybernetics : Array[Cybernetic]



#STATS
@export var Max_HP : int = 1
@export var Resilience : int
@export var Strength : int
@export var Dexterity : int
@export var Perception : int
@export var CT : int


#The Temporary Stats
@export var hp : int = Max_HP

signal health_change(Max_HP: int, hp: int)

#Returns
func get_character_name():
	return CharacterName

func has_cybernetic(type: Cybernetic.CyberneticType) -> bool:
	for cybernetic in cybernetics:
		if cybernetic.cybernetic_type == type:
			return true

	return false

func get_stats_dict() -> Dictionary:
	return{
		"Max_HP" : Max_HP,
		"Resilience": Resilience,
		"Strength" : Strength,
		"Dexterity" : Dexterity,
		"CT" : CT
	}

#Sets up the basics of the resource. 
func set_up():
	hp = Max_HP

func change_health(amount: int):
	hp = min(max(hp+amount, 0), Max_HP)
	health_change.emit(Max_HP, hp)
	print("Change")

#Chooses an action based on AI
func ai_action(actor: Character_Entity, allies: Array[Character_Entity], opponents: Array[Character_Entity]) -> Action_Choice:
	if not enemyAI == null:
		return enemyAI.choose_action(actor, allies, opponents, move_list)
	else:
		return Globals.create_action_choice(Globals.BASIC_ATTACK, opponents[0])
	
