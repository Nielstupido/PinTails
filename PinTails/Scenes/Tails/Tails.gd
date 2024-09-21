class_name Tails
extends Object


enum Types {
	SCORPION,
	CHEETAH,
	GECKO,
	RHINO,
	PANGOLIN,
	PANTHER,
	CHAMELEON,
	MEERKAT,
	MANTISSHRIMP,
	MONKEY
}


func _init():
	printerr("The ", get_class(), " class is used only for global constants and should not be instantiated")
	self.free()
