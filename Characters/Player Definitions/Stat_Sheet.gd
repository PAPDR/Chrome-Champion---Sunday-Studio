extends Resource
class_name stat_sheet



#CHARACTER DEFINITION----
@export var CharacterName : String
@export var sprite : Texture

#STATS
@export var HP : int = 1
@export var Resilience : int
@export var Strength : int
@export var Dexterity : int
@export var Perception : int
@export var CT : int

#Returns
func get_character_name():
	return CharacterName

func get_stats_dict() -> Dictionary:
	return{
		"HP" : HP,
		"Resilience": Resilience,
		"Strength" : Strength,
		"Dexterity" : Dexterity,
		"CT" : CT
	}
