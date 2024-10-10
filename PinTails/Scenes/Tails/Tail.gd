class_name Tail
extends Object


enum Classes {
	Scorpion,
	Cheetah,
	Gecko,
	Rhino,
	Pangolin,
	Panther,
	Chameleon,
	Meerkat,
	Mantis_Shrimp,
	Monkey
}


func _init():
	printerr("The ", get_class(), " class is used only for global constants and should not be instantiated")
	self.free()
