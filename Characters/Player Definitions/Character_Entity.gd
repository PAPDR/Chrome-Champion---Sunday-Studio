@tool
extends Node2D
#Character Entity defines a character with stats, moves etc
class_name Character_Entity




signal turn_ended(character: Character_Entity) #End signal that tells the controller that the turn has ended
signal turn_started(character: Character_Entity) #Start Turn Signal

@onready var character_sprite = $CharacterSprite
@onready var healthbar = $HealthBar


signal character_entity_ready



#Sheet that contains the stat_sheet
@export var stat_sheet_instance: stat_sheet:
	set(value):
		stat_sheet_instance = value
		if Engine.is_editor_hint():
			update_character_sprite()
var is_bracing : bool=false
var metal_bones_active : bool = false

var vantage_eye_active : bool = false
var vantage_eye_turns_remaining : int = 0

	

#-------------------------------------------------------
#Tells the entity that their turn has started
#This function should be used to actually control the actions the entity takes during their turns.
#Note: Enemies can use AI script pre-made. (ie: always attacks or random)
func take_turn():
	turn_started.emit(self)
	
	pass


#Ends the turn. Emits the turn_ended signal telling the controller that the turn ends.
func end_turn():
	turn_ended.emit(self)

#Do Actions
func character_action(action: Action):
	#This functions has the character perform a specific action
	#ie: Attack, etc
	pass

func take_damage(damage: int):
	if is_bracing:
		var reduction = min(stat_sheet_instance.Resilience * 0.02, 0.5)
		damage = roundi(damage * (1.0 - reduction))
		is_bracing = false
		
	stat_sheet_instance.change_health(-1 * damage)

func get_actions_per_turn() -> int:
	var actions_per_turn = 1

	if stat_sheet_instance.has_cybernetic(Cybernetic.CyberneticType.HYDRAULIC_LEGS):
		actions_per_turn += 1

	return actions_per_turn
	
func activate_metal_bones():
	if stat_sheet_instance.has_cybernetic(Cybernetic.CyberneticType.METAL_BONES):
		metal_bones_active = true
		
func activate_vantage_eye():
	if stat_sheet_instance.has_cybernetic(Cybernetic.CyberneticType.VANTAGE_EYE):
		vantage_eye_active = true
		vantage_eye_turns_remaining = 2
		



func _ready():
	print("sprite: ", character_sprite)
	update_character_sprite()
	stat_sheet_instance.health_change.connect(update_health)
	
	

func update_character_sprite():
	if stat_sheet_instance == null:
		print("ERROR: Stat sheet is missing")
		return
	if stat_sheet_instance.sprite == null || character_sprite == null:
		print("ERROR: CharacterSprite is missing")
		return

	character_sprite.texture = stat_sheet_instance.sprite
	character_sprite.visible = true


#HP BAR
func health_set_up():
	healthbar.max_value = stat_sheet_instance.Max_HP
	healthbar.value = stat_sheet_instance.hp

func update_health():
	healthbar.value = stat_sheet_instance.hp
