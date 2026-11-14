extends Resource
class_name Action

enum ScalingStat {
	STRENGTH,
	DEXTERITY,
	RESISTENCE,
	CT,
	NONE
}


@export var name : String
@export var dialogue_description : String


@export var accuracy : float
@export var valid_target : Globals.action_target
@export var base_damage : float

@export var scaling_stat : ScalingStat
@export var Scaling_multiplier : float = 1.0
