extends Control

@onready var tail_cards_holder = self.get_parent().get_parent().get_parent()
var tail_data : TailData


func prepare_tail_card(passed_tail_data):
	tail_cards_holder.connect("on_tail_card_pressed", Callable(self, "_on_tail_card_pressed"))
	if passed_tail_data != null:
		self.tail_data = passed_tail_data
		$Title.text = STRINGHELPER.filter_string(Tail.Classes.find_key(self.tail_data.tail_class))


func _on_tail_card_pressed(selected_tail_data):
	if self.tail_data == selected_tail_data:
		$Bg.color.a = 0.6
	else:
		$Bg.color.a = 1


func _on_Button_pressed():
	owner.player_selected_tail(PLAYERACCOUNT.username, self.tail_data)
	tail_cards_holder.emit_signal("on_tail_card_pressed", self.tail_data)
