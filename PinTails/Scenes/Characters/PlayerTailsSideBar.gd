extends Control


@onready var box_container = $VBoxContainer
@onready var tail_label1 = $VBoxContainer/Control/Label
@onready var tail_label2 = $VBoxContainer/Control2/Label
@onready var tail_label3 = $VBoxContainer/Control3/Label
var _acqrd_tails : int = 0


func _ready():
	GAMEPLAYMANAGER.connect("tail_picked_up", Callable(self, "add_tail"))


func add_tail(tail_data):
	box_container.get_child(_acqrd_tails).get_child(0).text = STRINGHELPER.filter_string(Tail.Classes.find_key(tail_data.tail_class))
	_acqrd_tails += 1


func remove_tail(removed_tail_key):
	_acqrd_tails -= 1
	
	if removed_tail_key == 0:
		tail_label1.text = tail_label2.text
	
	if removed_tail_key == 0 or removed_tail_key == 1:
		tail_label2.text = tail_label3.text
	
	tail_label3.text = "Empty"
