class_name TailTypes
extends Object


enum Types {
	SCORPION, 
	CHEETAH, 
	GECKO, 
	RHINO
}


func _init():
	printerr("The ", get_class(), " class is used only for global constants and should not be instantiated")
	self.free()
