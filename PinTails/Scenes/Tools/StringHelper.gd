@tool
extends Node


func filter_string(unfiltered_string : String) -> String:
	if unfiltered_string.contains("_"):
		return unfiltered_string.replace("_", " ")
	
	if unfiltered_string.contains(" "):
		return unfiltered_string.replace(" ", "")
	
	return unfiltered_string
