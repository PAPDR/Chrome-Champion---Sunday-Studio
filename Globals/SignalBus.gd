extends Node

#Signal Bus is a global Script that handles all the signals used
signal finished_dialogue

signal combat_ready

#ACTION BUTTON SIGNALS
signal hovering_button(button : Action_Button)
signal exit_hover_button(button : Action_Button)
signal action_button_press(button : Action_Button)

signal target_selected(sheet : stat_sheet)
