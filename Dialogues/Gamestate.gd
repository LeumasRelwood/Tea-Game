extends Node

func conversation_finished():
	get_tree().call_group("NPCs", "conversation_finished")

var player_name : String = "Player"
var has_met_harbormaster = false
var warehouse_unlocked = false
var shipping_unlocked = false
