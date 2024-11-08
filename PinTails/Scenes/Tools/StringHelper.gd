@tool
extends Node


func filter_string(unfiltered_string : String, do_combine : bool = false, symbol : String = "") -> String:
	if do_combine:
		return unfiltered_string.replace(symbol, "")
	
	if unfiltered_string.contains("_"):
		return unfiltered_string.replace("_", " ")
	
	if unfiltered_string.contains(" "):
		return unfiltered_string.replace(" ", "")
	
	var string_res = is_sticked_together(unfiltered_string)
	if string_res[0]:
		string_res[1]
		return unfiltered_string.left(string_res[1]) + " " + unfiltered_string.right(-(string_res[1]))
	
	return unfiltered_string


func is_sticked_together(unfiltered_string : String) -> Array:
	for letter in unfiltered_string:
		if letter == letter.capitalize() and letter != unfiltered_string[0]:
			return [true, unfiltered_string.rfind(letter)]
	
	return [false, 0]
