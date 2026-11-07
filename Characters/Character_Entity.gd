extends Node2D
#Character Entity defines a character with stats, moves etc
class_name Entity

#End signal that tells the controller that the turn has ended
signal turn_ended



#Tells the entity that their turn has started
#This function should be used to actually control the actions the entity takes during their turns.
#Note: Enemies can use AI script pre-made. (ie: always attacks or random)
func take_turn():
	
	
	pass


#Ends the turn. Emits the turn_ended signal telling the controller that the turn ends.
func end_turn():
	turn_ended.emit()

#Do Actions
func character_action(action: Action):
	#This functions has the character perform a specific action
	#ie: Attack, etc
	
	pass
