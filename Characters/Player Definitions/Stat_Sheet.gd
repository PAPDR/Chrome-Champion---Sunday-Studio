extends Resource
class_name stat_sheet



#CHARACTER DEFINITION----
@export var CharacterName : String
@export var sprite : Texture

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
