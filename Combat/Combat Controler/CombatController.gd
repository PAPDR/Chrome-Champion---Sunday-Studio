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

@export_group("Fighter Setup")

@export var player_entity_scene: PackedScene
@export var enemy_entity_scene: PackedScene

@export var player_team: Array[stat_sheet]
@export var enemy_team: Array[stat_sheet]

@export var player_spawn_points: Node2D
@export var enemy_spawn_points: Node2D

@export var player_fighters_container: Node2D
@export var enemy_fighters_container: Node2D

@onready var combat_ui = $"../CombatUI"


var last_action_used : Action_Choice 


func _ready():
	spawn_team(
		player_team,
		player_entity_scene,
		player_spawn_points,
		player_fighters_container
	)
	spawn_team(
		enemy_team,
		enemy_entity_scene,
		enemy_spawn_points,
		enemy_fighters_container
	)
	
	print("Fighters spawned: ", initiative_order.size())
	if initiative_order.size() > 0:
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
			
		
func spawn_team(
	team: Array[stat_sheet],
	entity_scene: PackedScene,
	spawn_points: Node2D,
	fighter_container: Node2D
):
	var points = spawn_points.get_children()
	for i in range(team.size()):
		# Make sure we have a spawn point available
		if i >= points.size():
			push_warning("Not enough spawn points for this team!")
			break

		# Create a fighter from the appropriate scene
		var fighter = entity_scene.instantiate() as Character_Entity
		print("Spawned scene: ", fighter.scene_file_path)
		print("Sprite node: ", fighter.get_node_or_null("CharacterSprite"))

		# Give this fighter its own copy of its stats
		fighter.stat_sheet_instance = team[i].duplicate(true)
		fighter.stat_sheet_instance.set_up()

		# Add the fighter to the scene and position it
		fighter_container.add_child(fighter)
		fighter.global_position = points[i].global_position
		

		# Register the fighter with the combat controlle
		add_to_initiative(fighter)

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
	combat_ui.show_action_panel()
	await dialogue_state(DialogueStorage.PLAYER_COMBAT)
	do_action(character, Globals.create_action_choice(Globals.BASIC_ATTACK, enemy_character_list[0]))
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
	match move.action_type:
		Action.ActionType.ATTACK:
			character.is_bracing = false
			target.take_damage(Globals.damage_calculation(character, target, move))

		Action.ActionType.DEFENSE:
			if move.name == "Brace":
				character.is_bracing = true	
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
	
