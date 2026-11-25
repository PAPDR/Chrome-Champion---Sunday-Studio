extends Node2D
class_name NewCombatController
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

@export var combat_selection : CombatSelection

#Placement Values
#NOTE: Need to make this dynamic somehow, rightnow hardcoded
@export var enemy_placement : Node2D
@export var player_placement : Node2D
var player_placement_children : Array[Marker2D]
var enemy_placement_children : Array[Marker2D]

#Combat Variables
var last_action_used : Action_Choice 
var target : Character_Entity #Target of ability or action


#Player Choice Signal
signal player_choice_made(Action)


func _ready():
	#Set Up Singals
	SignalBus.action_button_press.connect(action_button_pressed)
	SignalBus.combat_ready.connect(start_combat)#Allows combat to start
	SignalBus.target_selected.connect(target_selected)
	
	#Gets position ready
	for child in player_placement.get_children():
		player_placement_children.append(child)
	
	for child in enemy_placement.get_children():
		enemy_placement_children.append(child)

	
	
#Starts combat from the start of the round
func start_combat():
	var turn_character: Character_Entity = initiative_order[initiative_point]["character"]
	print(turn_character)
	start_turn(turn_character)
	pass

#For testing, state machine should not depend on process
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		player_character_list[0].take_damage(2)

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
		#Each health bar gets added and connects damage to itself
		#TODO: Add way to remove healthbar on death
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
	turn_off_dialogue()
	combat_selection.visible = true
	#Fill the Combat UI with character data
	combat_selection.set_up_character(character)
	#TEMP - Fill Enemy Target (default 0)
	combat_selection.set_up_enemy(enemy_character_list[0])
	var action_chosen : Action = await player_choice_made
	#Does the action
	do_action_target(character, action_chosen, enemy_character_list[0])
	combat_selection.visible = false
	turn_off_dialogue()
	new_turn_start()
	pass

#Start of the enemy turn. 
#Note: Stores the last action used, and uses the ai script to decide what to do.
func start_enemy_turn(character: Character_Entity):
	print("Start Enemy Turn")
	var turn_action = character.stat_sheet_instance.ai_action(character, enemy_character_list, player_character_list)
	last_action_used = turn_action
	await dialogue_state(DialogueStorage.ENEMY_TURN)
	
	await do_action(character, turn_action) #Performs the actual action
	
	turn_ended(character)
	pass

#Used when turn ends
#NOTE: May need to add things here to remove buffs/debuffs/do DOT damage
func turn_ended(character: Character_Entity):
	await dialogue_state(DialogueStorage.TURN_ENDED)
	new_turn_start()

#Adjusts the initiative and runs the start turn
func new_turn_start():
	var new_initaitve = (initiative_point + 1) % initiative_order.size()
	initiative_point = new_initaitve
	var turn_character : Character_Entity = initiative_order[initiative_point]["character"]
	start_turn(turn_character)

#Creates the dialogue state based with the allocated option
func dialogue_state(dialogue_option : Resource):
	combat_dialogue.dialogue_resource = dialogue_option
	combat_dialogue.start()
	await DialogueManager.dialogue_ended
	await get_tree().process_frame

func turn_off_dialogue():
	combat_dialogue.visible = false
	combat_dialogue.will_block_other_input = false

func turn_on_dialogue():
	combat_dialogue.visible = true
	combat_dialogue.will_block_other_input = false


#do_action performs the actual action decided by player or AI.
#It needs to verify what it is doing (damaging or healing, or etc)
#Needs to verify that everything is legal (no crashing)
#Needs to handle animation
#TODO:
#Check for healing, boasting, items, etc
#MAY NOT BE DAMAGE
func do_action(character: Character_Entity, action_choice: Action_Choice):
	var move = action_choice.action
	var target = action_choice.target
	
	target.take_damage(Globals.damage_calculation(character, target, move))

#Runs Do action but uses action and target seperatly
func do_action_target(character: Character_Entity, action: Action, target: Character_Entity):
	var action_choice : Action_Choice = Action_Choice.new()
	action_choice.action = action
	action_choice.target = target
	do_action(character, action_choice)
#----------------------------------------------------------

#----------------------------------------------------------
#SIGNALS
func action_button_pressed(button : Action_Button):
	print(button)
	player_choice_made.emit(button.action)


func target_selected(stat : stat_sheet):
	combat_selection.fill_enemy_stats(stat)

#------------------------------------------------------------
#COMBAT SELECTION

func spawn_player(stats : stat_sheet):
	var player : Player_Entity = Globals.PLAYER_CHARACTER_ENTITY.instantiate()
	player.stat_sheet_instance = stats
	#Set Up Everything Needed
	add_child(player)
	add_to_initiative(player)
	
	#Change the Sprite
	player.transform = player_placement_children[player_character_list.size()].transform

func spawn_enemy(stats : stat_sheet):
	var enemy : Enemy_Character_Entity = Globals.ENEMY_CHARACTER_ENTITY.instantiate()
	enemy.stat_sheet_instance = stats
	#Set Up Everything Needed
	add_child(enemy)
	add_to_initiative(enemy)
	
	#Change the Sprite
	enemy.transform = enemy_placement_children[enemy_character_list.size()].transform


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
