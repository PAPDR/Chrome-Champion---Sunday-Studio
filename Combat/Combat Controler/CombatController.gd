extends Node2D
class_name CombatController
#Combat Controller controls the actual order of the characters, enemies etc
#It will handle damage, and anything not directly managed by the entities themselves

var player_character_list : Array[Character_Entity] = []
var enemy_character_list : Array[Character_Entity] = [] #Keep list of enemies and players seperate
var initiative_order: Array[Dictionary] = []
var initiative_point : int = 0 #Where in the initiative order it is
@export var enemy_health_bars : VBoxContainer
@export var ally_health_bars : VBoxContainer
@export var health_bar_scene: PackedScene
@export var combat_dialogue : CanvasLayer

var last_action_used : Action_Choice 


func _ready():
	#At initialization move all children to initiative
	for child in get_children():
		add_to_initiative(child)
	print(initiative_order.size())
	start_combat()
	
#Starts combat from the start of the round
func start_combat():
	var turn_character: Character_Entity = initiative_order[initiative_point]["character"]
	print(turn_character)
	start_turn(turn_character)
	pass

#For testing, state machine should not depend on process
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		enemy_character_list[0].take_damage(2)

func add_to_initiative(character : Node = null, initiative : int = 0):
	if  character is Character_Entity:
		#Add character initiative combo into the list
		initiative_order.append({
			"character" : character,
			"initiative_value" : initiative
		})
		
		#Sorts the dictionary list by the initiative values (highest goes first)
		initiative_order.sort_custom(
			func(a, b): return a["initiative_value"] > b["initiative_value"]
		)
		
		#Connect Health bar to enemy
		if character is Enemy_Character_Entity:
			enemy_character_list.append(character)
			var bar : CombatHealthBar = health_bar_scene.instantiate()
			enemy_health_bars.add_child(bar)
			bar.setup(character)
		else:
			player_character_list.append(character)
			var bar : CombatHealthBar = health_bar_scene.instantiate()
			ally_health_bars.add_child(bar)
			bar.setup(character)
			
		


#STATE MACHINE CONTROLLER ----------------------------------------------
func start_turn(character: Character_Entity):
	await dialogue_state(DialogueStorage.COMBAT_TURN_START)
	if(character is Player_Entity):
		start_player_turn(character)
	else:
		start_enemy_turn(character)

#Starts the player turn (activates player related UI)
func start_player_turn(character: Player_Entity):
	print("Start Player Turn")
	await dialogue_state(DialogueStorage.PLAYER_COMBAT)
	new_turn_start()
	pass

func start_enemy_turn(character: Character_Entity):
	print("Start Enemy Turn")
	var turn_action = character.stat_sheet_instance.ai_action(character, enemy_character_list, player_character_list)
	last_action_used = turn_action
	await dialogue_state(DialogueStorage.ENEMY_TURN)
	turn_ended(character)
	pass

func turn_ended(character: Character_Entity):
	await dialogue_state(DialogueStorage.TURN_ENDED)
	new_turn_start()

func new_turn_start():
	var new_initaitve = (initiative_point + 1) % initiative_order.size()
	initiative_point = new_initaitve
	var turn_character : Character_Entity = initiative_order[initiative_point]["character"]
	start_turn(turn_character)

func dialogue_state(dialogue_option : Resource):
	combat_dialogue.dialogue_resource = dialogue_option
	combat_dialogue.start()
	await DialogueManager.dialogue_ended
	await get_tree().process_frame
#----------------------------------------------------------

#GET INFO-------------------------------------------------------
func get_enemy_list() -> Array:
	return enemy_character_list

func get_player_list() -> Array:
	return player_character_list

func get_turn_entity() -> Character_Entity:
	return initiative_order[initiative_point]["character"]
	
func get_turn_entity_name() -> String:
	var character : Character_Entity = initiative_order[initiative_point]["character"]
	print(character.stat_sheet_instance.CharacterName)
	return character.stat_sheet_instance.CharacterName

func get_action_used() -> Action_Choice:
	return last_action_used
