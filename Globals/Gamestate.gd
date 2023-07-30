extends Node

func conversation_finished():
	get_tree().call_group("NPCs", "conversation_finished")

var player_name : String = "Player"
var reputation : int = 0

var npc_name : String = " "
var random_dialog_options
var random_dialog_line
func random_dialog_choose():
	random_dialog_line = randi_range(1, random_dialog_options)
	print(random_dialog_line)
	
var has_met_harbormaster = false
var warehouse_unlocked = false
var shipping_unlocked = false
