extends Node2D
#Character Entity defines a character with stats, moves etc
class_name Character_Entity


signal turn_ended(character: Character_Entity) #End signal that tells the controller that the turn has ended
signal turn_started(character: Character_Entity) #Start Turn Signal


#CHARACTER DEFINITION----
@export var Name : String
@export var Sprite : Sprite2D

#STATS
@export var HP : int = 1
@export var Resilience : int
@export var Strength : int
@export var Dexterity : int
@export var Perception : int
@export var CT : int



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
