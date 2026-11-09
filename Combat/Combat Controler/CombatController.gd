extends Node2D
#Combat Controller controls the actual order of the characters, enemies etc
#It will handle damage, and anything not directly managed by the entities themselves

var player_character_list : Array = []
var enemy_character_list : Array = [] #Keep list of enemies and players seperate
var initiative_order: Array[Dictionary] = []
var initiative_point : int = 0 #Where in the initiative order it is
@export var dialogue: Control



func _ready():
	#At initialization move all children to initiative
	for child in get_children():
		add_to_initiative(child)
	print(initiative_order.size())

#Primarily for testing -
func _process(delta):
	#These are just to test if the mechanics are working, remove
	if Input.is_action_just_pressed("ui_accept"):
		print(initiative_order[initiative_point].get("character"))
	if Input.is_action_just_pressed("ui_down"):
		initiative_point = (initiative_point + 1) % (initiative_order.size())
		print(initiative_point)
		
		

#Starts combat from the start of the round
func start_combat():
	pass



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
		

func start_turn(character: Character_Entity):
	if(character is Player_Entity):
		start_player_turn(character)
	else:
		start_enemy_turn(character)

#Starts the player turn (activates player related UI)
func start_player_turn(character: Player_Entity):
	pass

func start_enemy_turn(character: Character_Entity):
	pass

func get_enemy_list() -> Array:
	return enemy_character_list

func get_player_list() -> Array:
	return player_character_list
