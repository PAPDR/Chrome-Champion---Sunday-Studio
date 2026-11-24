extends Node2D

@onready var new_combat_controller = $NewCombatController
const CHAD = preload("uid://ibne1chxnhq1")
const JACK = preload("uid://btan8tnxfsgtn")

@export var players : Array[stat_sheet]
@export var enemies : Array[stat_sheet]

func _ready():
	#Make Children
	#new_combat_controller.spawn_player(CHAD)
	#new_combat_controller.spawn_enemy(JACK)
	
	for stat in players:
		new_combat_controller.spawn_player(stat)
	
	for stat in enemies:
		new_combat_controller.spawn_enemy(stat)
	#STARTS COMBAT -------------------------
	SignalBus.combat_ready.emit()
