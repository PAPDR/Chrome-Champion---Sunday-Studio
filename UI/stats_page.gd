
extends Control

@export var portrait: TextureRect 
@export var bio: RichTextLabel 
@export var character_name: Label 
@export var character_class: Label 
@export var stat_grid: GridContainer 




func set_data(stats: stat_sheet) -> void:
		character_name.text = stats.CharacterName
		portrait.texture = stats.sprite
		display_stats(stats.get_stats_dict())

func display_stats(stats: Dictionary) -> void:
	for stat_name in stats:
		var name_label := Label.new()
		name_label.text = str(stat_name)
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var value_label := Label.new()
		value_label.text = str(stats[stat_name])
		value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

		stat_grid.add_child(name_label)
		stat_grid.add_child(value_label)
