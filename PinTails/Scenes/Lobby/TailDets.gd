extends Control

@onready var tail_cards_holder = $"../TailCardsHolder"
var current_tail_data : TailData


func _ready():
	tail_cards_holder.connect("on_tail_card_pressed", Callable(self, "_on_tail_card_pressed"))
	self.hide()


func _on_tail_card_pressed(tail_data):
	if !self.is_visible_in_tree(): 
		self.show()
	current_tail_data = tail_data
	$Title.text = StringHelper.filter_string(Tail.Classes.find_key(current_tail_data.tail_class))
	$Atrribs.text = current_tail_data.attrb_str
