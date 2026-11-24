extends Control
class_name  CombatSelection

@onready var action_description = $ActionDescription
@onready var stat_labels = $"Stat Labels"
@onready var target_stat_labels = $"Target Stat Labels"



#Textures
@onready var player_head_shot = $Background/PlayerHeadShot
@onready var enemy_head_shot = $Background/EnemyHeadShot



func _ready():
	SignalBus.hovering_button.connect(on_hover_button)
	SignalBus.exit_hover_button.connect(on_exit_hover_button)

func on_hover_button(button : Action_Button):
	action_description.text = button.hover_description
	pass

func on_exit_hover_button(button : Action_Button):
	pass

func set_up_character(character : Character_Entity):
	#Set up the headshot
	var stats : stat_sheet = character.stat_sheet_instance
	player_head_shot.texture = stats.headshot
	
	#Set up the stats
	fill_player_stats(stats)

func set_up_enemy(character : Character_Entity):
	var stats : stat_sheet = character.stat_sheet_instance
	enemy_head_shot.texture = stats.headshot
	
	#Set up the stats
	fill_enemy_stats(stats)

func fill_player_stats(stats : stat_sheet):
	var stats_dictionary = stats.get_stats_dict()
	
	for child in stat_labels.get_children():
		child.queue_free()
	
	for stat_name in stats_dictionary:
		var name_label := Label.new()
		name_label.text = str(stat_name)
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var value_label := Label.new()
		value_label.text = str(stats[stat_name])
		value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

		stat_labels.add_child(name_label)
		stat_labels.add_child(value_label)

func fill_enemy_stats(stats : stat_sheet):
	#remove all children
	for child in target_stat_labels.get_children():
		child.queue_free()
	
	var stats_dictionary = stats.get_stats_dict()
	
	for stat_name in stats_dictionary:
		var name_label := Label.new()
		name_label.text = str(stat_name)
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var value_label := Label.new()
		value_label.text = str(stats[stat_name])
		value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

		target_stat_labels.add_child(name_label)
		target_stat_labels.add_child(value_label)
