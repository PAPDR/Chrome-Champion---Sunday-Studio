extends Node2D

@onready var new_combat_controller = $NewCombatController
const CHAD = preload("uid://ibne1chxnhq1")
const JACK = preload("uid://btan8tnxfsgtn")

func _ready():
	#Make Children
	new_combat_controller.spawn_player(CHAD)
