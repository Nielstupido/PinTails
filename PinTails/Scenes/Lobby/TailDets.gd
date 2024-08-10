extends Control


var current_tail_data : TailData


func _ready():
	owner.get_node("TailCardsHolder").connect("on_tail_card_pressed", Callable(self, "_on_tail_card_pressed"))
	self.hide()


func _on_tail_card_pressed(tail_data):
	if !self.is_visible_in_tree():
		self.show()
	current_tail_data = tail_data
	$Title.text = current_tail_data.tail_name
	$Atrribs.text = current_tail_data.tail_attrb_str
