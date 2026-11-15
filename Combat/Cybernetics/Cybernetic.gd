extends Resource
class_name Cybernetic

enum CyberneticType {
	EHANCED_ARMS,
	HYDRAULIC_LEGS,
	METAL_BONES,
	VANTAGE_EYE
}

@export var cybernetic_name : String
@export var description : String
@export var cybernetic_type : CyberneticType
@export var granted_action : Action

@export var damage_reduction : float = 0.0

@export var critical_chance_multiplier : float = 1.0
@export var duration_turns : int = 0
