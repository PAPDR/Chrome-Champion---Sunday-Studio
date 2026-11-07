extends Node2D
#Combat Controller controls the actual order of the characters, enemies etc
#It will handle damage, and anything not directly managed by the entities themselves

var initiative_order: Array[Dictionary] = []

func _init():
	#At initialization move all children to initiative
	for child in get_children():
		print("hi")
		add_to_initiative(child)
	
	print(initiative_order.size())

#Starts combat from the start of the round
func start_combat():
	pass

#Basic damage calculation
func damage_calculation(attacker: Character_Entity, defender: Character_Entity, action: Action) -> int:
	return max(attacker.Strength - defender.Resilience, 0)

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
		
		
	
